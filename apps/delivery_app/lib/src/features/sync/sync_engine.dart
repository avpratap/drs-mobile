import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';

import '../../data/delivery_database.dart';
import '../../data/pod_files.dart';

enum SyncOutcome { done, offline, busy }

/// Replays queued rider actions against the backend, oldest first.
///
/// * Idempotent: each action's id is sent as `Idempotency-Key`, so a retry
///   after a lost response is replayed by the server, never applied twice.
/// * The POD photo is uploaded once; its `media:` ref is persisted before the
///   status update, so a retry never re-uploads.
/// * Connectivity / server errors stop the run and keep the action queued.
/// * 409 (stop no longer open) is reconciled against the server: if the stop
///   is already terminal the action is done, otherwise it needs the rider.
/// * Other 4xx (validation) mark the action failed for the rider to review.
class SyncEngine {
  SyncEngine({
    required this._api,
    required this._db,
    required this._files,
    Future<MultipartFile> Function(String path)? readPhoto,
  }) : _readPhoto = readPhoto ?? _fromFile;

  static Future<MultipartFile> _fromFile(String path) => MultipartFile.fromFile(
    path,
    filename: 'pod.jpg',
    contentType: DioMediaType('image', 'jpeg'),
  );

  final Future<MultipartFile> Function(String path) _readPhoto;
  final DeliveryApi _api;
  final DeliveryDatabase _db;
  final PodFiles _files;
  bool _running = false;

  Future<SyncOutcome> run() async {
    if (_running) return SyncOutcome.busy;
    _running = true;
    try {
      for (final action in await _db.queued()) {
        if (!await _process(action)) return SyncOutcome.offline;
      }
      return SyncOutcome.done;
    } finally {
      _running = false;
    }
  }

  /// Returns false when the run should stop (offline / server trouble).
  Future<bool> _process(PendingAction a) async {
    final payload = jsonDecode(a.payload) as Map<String, dynamic>;
    try {
      if (a.kind == 'deliver') {
        var ref = a.photoRef;
        if (ref == null && a.photoPath != null) {
          final file = await _readPhoto(a.photoPath!);
          ref = (await _api.uploadPodAsset(file: file)).data!.url;
          await _db.setPhotoRef(a.id, ref);
        }
        await _api.deliverOrder(
          orderId: a.orderId,
          idempotencyKey: a.id,
          deliverRequest: DeliverRequest(
            items: [
              for (final i
                  in (payload['items'] as List).cast<Map<String, dynamic>>())
                DeliverItem(
                  productId: i['product_id'] as int,
                  qtyDelivered: i['qty_delivered'] as num,
                ),
            ],
            pod: PODIn(photoUrl: ref, note: payload['note'] as String?),
          ),
        );
      } else {
        await _api.failDeliveryOrder(
          orderId: a.orderId,
          idempotencyKey: a.id,
          failIn: FailIn(reason: payload['reason'] as String),
        );
      }
      await _complete(a);
      return true;
    } on Object catch (e) {
      final err = DrsApiError.from(e);
      if (err.isConnectivity ||
          err.kind == DrsApiErrorKind.server ||
          err.kind == DrsApiErrorKind.rateLimited ||
          err.kind == DrsApiErrorKind.unauthorized) {
        await _db.recordAttempt(a.id, err.message, failed: false);
        return false;
      }
      if (err.statusCode == 409 && await _alreadySettled(a, payload)) {
        await _complete(a);
        return true;
      }
      await _db.recordAttempt(a.id, err.message, failed: true);
      return true;
    }
  }

  /// Whether the server already shows the stop as terminal (delivered or
  /// failed) — e.g. a replay outside the idempotency window.
  Future<bool> _alreadySettled(
    PendingAction a,
    Map<String, dynamic> payload,
  ) async {
    try {
      final day = DateTime.parse(payload['date'] as String);
      final stops = (await _api.deliveryRoute(date: day)).data ?? const [];
      final stop = stops.where((s) => s.order.id == a.orderId).firstOrNull;
      return stop != null && !DeliveryStatus.parse(stop.order.status).isOpen;
    } on Object {
      return false;
    }
  }

  Future<void> _complete(PendingAction a) async {
    await _db.remove(a.id);
    await _files.discard(a.photoPath);
  }
}
