import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';

import '../../data/delivery_database.dart';
import '../../data/pod_files.dart';
import 'retry_policy.dart';

enum SyncOutcome {
  done,

  /// No connection: everything stays queued; retried when the network is back.
  offline,

  /// The server was erroring / rate-limiting: the action backs off.
  serverTrouble,

  /// Another run is in progress.
  busy,
}

/// Replays queued rider actions against the backend, oldest first.
///
/// * Idempotent: each action's id is sent as `Idempotency-Key`, so a retry
///   after a lost response is replayed by the server, never applied twice.
/// * The POD photo is uploaded once; its `media:` ref is persisted before the
///   status update, so a retry never re-uploads.
/// * No connection stops the run; actions stay queued and are retried when
///   the network returns (no backoff — nothing was sent).
/// * Server errors / 429 stop the run and back the action off exponentially
///   with jitter (see [retryDelay]); `Retry-After` is honoured. Automatic
///   runs skip actions that aren't due yet; a manual "Sync now" doesn't.
/// * Actions for the same stop run in order: a later one never overtakes an
///   earlier one that is backing off.
/// * 409 (stop no longer open) / 404 (not on the route any more) are
///   reconciled against the server: same outcome already recorded → done;
///   a different outcome or a reassigned stop → `conflict`, explained to the
///   rider, who acknowledges it and then sees the server's version.
/// * Other 4xx (validation) mark the action failed for the rider to review.
class SyncEngine {
  SyncEngine({
    required this._api,
    required this._db,
    required this._files,
    Future<MultipartFile> Function(String path)? readPhoto,
    DateTime Function()? clock,
    Random? random,
  }) : _readPhoto = readPhoto ?? _fromFile,
       _clock = clock ?? DateTime.now,
       _random = random ?? Random();

  final DateTime Function() _clock;
  final Random _random;

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

  /// [force] (rider tapped "Sync now") ignores backoff.
  Future<SyncOutcome> run({bool force = false}) async {
    if (_running) return SyncOutcome.busy;
    _running = true;
    try {
      final now = _clock();
      final blocked = <int>{}; // stops with an earlier action waiting
      for (final action in await _db.queued()) {
        final due =
            force ||
            action.nextAttemptAt == null ||
            !action.nextAttemptAt!.isAfter(now);
        if (!due || blocked.contains(action.orderId)) {
          blocked.add(action.orderId);
          continue;
        }
        final outcome = await _process(action);
        if (outcome != SyncOutcome.done) return outcome;
      }
      return SyncOutcome.done;
    } finally {
      _running = false;
    }
  }

  /// [SyncOutcome.done] to continue with the next action, otherwise why the
  /// run should stop.
  Future<SyncOutcome> _process(PendingAction a) async {
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
      return SyncOutcome.done;
    } on Object catch (e) {
      final err = DrsApiError.from(e);
      if (err.isConnectivity || err.kind == DrsApiErrorKind.unauthorized) {
        // Nothing reached the server (or the session is being refreshed):
        // keep it due; the network/session coming back triggers the retry.
        await _db.recordAttempt(a.id, err.message);
        return SyncOutcome.offline;
      }
      if (err.kind == DrsApiErrorKind.server ||
          err.kind == DrsApiErrorKind.rateLimited) {
        final retryAfter = e is DioException
            ? parseRetryAfter(
                e.response?.headers.value('retry-after'),
                now: _clock(),
              )
            : null;
        final wait = retryDelay(
          a.attempts,
          random: _random,
          retryAfter: retryAfter,
        );
        await _db.recordAttempt(
          a.id,
          err.message,
          nextAttemptAt: _clock().add(wait),
        );
        return SyncOutcome.serverTrouble;
      }
      if (err.statusCode == 409 || err.statusCode == 404) {
        return _reconcile(a, payload, err);
      }
      await _db.recordAttempt(a.id, err.message, state: 'failed');
      return SyncOutcome.done;
    }
  }

  /// The server refused because the stop changed under us. Compare with what
  /// the server now says and settle the action.
  Future<SyncOutcome> _reconcile(
    PendingAction a,
    Map<String, dynamic> payload,
    DrsApiError original,
  ) async {
    final List<RouteStopOut> stops;
    try {
      final day = DateTime.parse(payload['date'] as String);
      stops = (await _api.deliveryRoute(date: day)).data ?? const [];
    } on Object catch (e) {
      // Can't check right now: keep it queued and try again later.
      final err = DrsApiError.from(e);
      await _db.recordAttempt(
        a.id,
        err.message,
        nextAttemptAt: _clock().add(retryDelay(a.attempts, random: _random)),
      );
      return err.isConnectivity
          ? SyncOutcome.offline
          : SyncOutcome.serverTrouble;
    }
    final stop = stops.where((s) => s.order.id == a.orderId).firstOrNull;
    if (stop == null) {
      await _db.recordAttempt(
        a.id,
        'This stop is no longer on your route — it was reassigned or '
        'removed by the office. Your update was not applied.',
        state: 'conflict',
      );
      return SyncOutcome.done;
    }
    final server = DeliveryStatus.parse(stop.order.status);
    final wanted = a.kind == 'fail'
        ? DeliveryStatus.failed
        : DeliveryStatus.delivered;
    if (server == wanted) {
      // Already recorded (e.g. a replay outside the idempotency window).
      await _complete(a);
      return SyncOutcome.done;
    }
    if (!server.isOpen) {
      await _db.recordAttempt(
        a.id,
        'The office already marked this stop as ${server.label.toLowerCase()}. '
        'Your "${wanted.label.toLowerCase()}" update was not applied.',
        state: 'conflict',
      );
      return SyncOutcome.done;
    }
    // Still open but refused: show the server's reason to the rider.
    await _db.recordAttempt(a.id, original.message, state: 'failed');
    return SyncOutcome.done;
  }

  Future<void> _complete(PendingAction a) async {
    await _db.remove(a.id);
    await _files.discard(a.photoPath);
  }
}
