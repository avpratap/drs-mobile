import 'dart:math' as math;

import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/providers.dart';
import '../stop/external_actions.dart';
import 'maps_key.dart';

/// The day's stops on a map. Uses Google Maps when a key is configured
/// (`--dart-define=DRS_GOOGLE_MAPS_API_KEY=…`); otherwise — or when no stop
/// has coordinates — degrades to a route sketch plus a hand-off to the maps
/// app, which needs no key.
class StopsMap extends ConsumerWidget {
  const StopsMap({required this.stops, required this.onSelect, super.key});

  final List<DeliveryStop> stops;
  final ValueChanged<DeliveryStop> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(envProvider);
    final located = stops.where((s) => s.hasCoordinates).toList();
    if (env.hasGoogleMaps && located.isNotEmpty) {
      return FutureBuilder<bool>(
        future: MapsKey.ensure(env.googleMapsApiKey),
        builder: (context, snap) => switch (snap.data) {
          true => _GoogleStopsMap(stops: located, onSelect: onSelect),
          false => _Fallback(
            stops: stops,
            onSelect: onSelect,
            reason: _Reason.keyRejected,
          ),
          null => const DrsLoading(),
        },
      );
    }
    return _Fallback(
      stops: stops,
      onSelect: onSelect,
      reason: env.hasGoogleMaps ? _Reason.noCoordinates : _Reason.noKey,
    );
  }
}

double _hue(DeliveryStatus s) => switch (s) {
  DeliveryStatus.delivered ||
  DeliveryStatus.partiallyDelivered => BitmapDescriptor.hueGreen,
  DeliveryStatus.failed => BitmapDescriptor.hueRed,
  DeliveryStatus.outForDelivery => BitmapDescriptor.hueOrange,
  _ => BitmapDescriptor.hueAzure,
};

class _GoogleStopsMap extends StatelessWidget {
  const _GoogleStopsMap({required this.stops, required this.onSelect});

  final List<DeliveryStop> stops;
  final ValueChanged<DeliveryStop> onSelect;

  @override
  Widget build(BuildContext context) {
    final sorted = [...stops]..sort((a, b) => a.sequence.compareTo(b.sequence));
    final points = [for (final s in sorted) LatLng(s.lat!, s.lng!)];
    final bounds = LatLngBounds(
      southwest: LatLng(
        points.map((p) => p.latitude).reduce(math.min),
        points.map((p) => p.longitude).reduce(math.min),
      ),
      northeast: LatLng(
        points.map((p) => p.latitude).reduce(math.max),
        points.map((p) => p.longitude).reduce(math.max),
      ),
    );
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: points.first, zoom: 13),
      // Keep the Google logo / controls clear of notches and home indicator.
      padding: MediaQuery.paddingOf(context),
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      onMapCreated: (c) => Future<void>.delayed(
        const Duration(milliseconds: 300),
        () => c.animateCamera(CameraUpdate.newLatLngBounds(bounds, 56)),
      ),
      markers: {
        for (final s in sorted)
          Marker(
            markerId: MarkerId('${s.orderId}'),
            position: LatLng(s.lat!, s.lng!),
            icon: BitmapDescriptor.defaultMarkerWithHue(_hue(s.status)),
            infoWindow: InfoWindow(
              title: '#${s.sequence} ${s.title}',
              snippet: s.status.label,
              onTap: () => onSelect(s),
            ),
          ),
      },
      polylines: {
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          width: 4,
          color: Theme.of(context).colorScheme.primary,
        ),
      },
    );
  }
}

enum _Reason { noKey, keyRejected, noCoordinates }

class _Fallback extends ConsumerWidget {
  const _Fallback({
    required this.stops,
    required this.onSelect,
    required this.reason,
  });

  final List<DeliveryStop> stops;
  final ValueChanged<DeliveryStop> onSelect;
  final _Reason reason;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final located = stops.where((s) => s.hasCoordinates).toList();
    final route = routeUri(stops);
    final dev = ref.watch(envProvider).allowDevOtpHint;
    final note = switch (reason) {
      _Reason.noKey when dev => 'Map preview needs DRS_GOOGLE_MAPS_API_KEY (--dart-define). Showing a route sketch.',
      _Reason.noCoordinates => 'These stops have no map location yet.',
      _ => 'Map preview is unavailable. Showing a route sketch.',
    };
    return LayoutBuilder(
      builder: (context, c) => SingleChildScrollView(
        padding: const EdgeInsets.all(DrsSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (located.length >= 2)
              Card(
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  height: math.min(320, math.max(200, c.maxHeight * 0.45)),
                  child: _RouteSketch(stops: located, onSelect: onSelect),
                ),
              ),
            const SizedBox(height: DrsSpacing.sm),
            Text(note, style: theme.textTheme.bodySmall),
            if (route != null) ...[
              const SizedBox(height: DrsSpacing.sm),
              DrsButton.secondary(
                label: 'Open route in Google Maps',
                icon: Icons.directions,
                onPressed: () => ref.read(urlOpenerProvider)(route),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Numbered stops on a normalised lat/lng plane, joined in route order.
class _RouteSketch extends StatelessWidget {
  const _RouteSketch({required this.stops, required this.onSelect});

  final List<DeliveryStop> stops;
  final ValueChanged<DeliveryStop> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = DrsColors.of(context);
    final sorted = [...stops]..sort((a, b) => a.sequence.compareTo(b.sequence));
    return LayoutBuilder(
      builder: (context, c) {
        final size = Size(c.maxWidth, c.maxHeight);
        final pts = _project(sorted, size);
        return Semantics(
          label: 'Route sketch with ${sorted.length} stops',
          child: GestureDetector(
            onTapUp: (d) {
              var best = -1;
              var bestDist = double.infinity;
              for (var i = 0; i < pts.length; i++) {
                final dist = (pts[i] - d.localPosition).distance;
                if (dist < bestDist) {
                  best = i;
                  bestDist = dist;
                }
              }
              if (best >= 0 && bestDist < 32) onSelect(sorted[best]);
            },
            child: CustomPaint(
              size: size,
              painter: _SketchPainter(
                points: pts,
                labels: [for (final s in sorted) '${s.sequence}'],
                colors: [
                  for (final s in sorted)
                    switch (s.status) {
                      DeliveryStatus.delivered ||
                      DeliveryStatus.partiallyDelivered => brand.success,
                      DeliveryStatus.failed => scheme.error,
                      _ => scheme.primary,
                    },
                ],
                line: scheme.outline,
                background: scheme.surfaceContainerLow,
                labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static List<Offset> _project(List<DeliveryStop> s, Size size) {
    const pad = 28.0;
    final lats = s.map((e) => e.lat!), lngs = s.map((e) => e.lng!);
    final minLat = lats.reduce(math.min), maxLat = lats.reduce(math.max);
    final minLng = lngs.reduce(math.min), maxLng = lngs.reduce(math.max);
    final dLat = (maxLat - minLat).abs() < 1e-9 ? 1.0 : maxLat - minLat;
    final dLng = (maxLng - minLng).abs() < 1e-9 ? 1.0 : maxLng - minLng;
    return [
      for (final e in s)
        Offset(
          pad + (e.lng! - minLng) / dLng * (size.width - 2 * pad),
          pad + (maxLat - e.lat!) / dLat * (size.height - 2 * pad),
        ),
    ];
  }
}

class _SketchPainter extends CustomPainter {
  _SketchPainter({
    required this.points,
    required this.labels,
    required this.colors,
    required this.line,
    required this.background,
    required this.labelStyle,
  });

  final List<Offset> points;
  final List<String> labels;
  final List<Color> colors;
  final Color line;
  final Color background;

  /// Brand font (a bare TextStyle would fall back to a platform font).
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = background);
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      i == 0
          ? path.moveTo(points[i].dx, points[i].dy)
          : path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 14, Paint()..color = colors[i]);
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: labelStyle),
        textScaler: TextScaler.noScaling, // fixed-size marker
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, points[i] - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_SketchPainter old) =>
      old.points != points || old.colors != colors;
}
