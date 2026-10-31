import 'package:drs_core/drs_core.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'external_actions.g.dart';

/// Opens URLs in other apps (maps, dialer). Overridden in tests.
typedef UrlOpener = Future<bool> Function(Uri uri);

@Riverpod(keepAlive: true)
UrlOpener urlOpener(Ref ref) =>
    (uri) => launchUrl(uri, mode: LaunchMode.externalApplication);

String _destination(DeliveryStop s) =>
    s.hasCoordinates ? '${s.lat},${s.lng}' : s.addressLine;

/// Turn-by-turn to one stop: Apple Maps on iOS, Google Maps elsewhere.
/// Works without any Maps API key (it hands off to the maps app).
Uri navigationUri(DeliveryStop s, TargetPlatform platform) =>
    platform == TargetPlatform.iOS
    ? Uri.https('maps.apple.com', '/', {
        'daddr': _destination(s),
        'dirflg': 'd',
      })
    : Uri.https('www.google.com', '/maps/dir/', {
        'api': '1',
        'destination': _destination(s),
        'travelmode': 'driving',
      });

/// The whole remaining route in Google Maps (destination + up to 9
/// waypoints, the URL API's limit).
Uri? routeUri(List<DeliveryStop> stops) {
  final open = [
    for (final s in stops)
      if (s.status.isOpen && (s.hasCoordinates || s.addressLine.isNotEmpty)) s,
  ]..sort((a, b) => a.sequence.compareTo(b.sequence));
  if (open.isEmpty) return null;
  final legs = open.take(10).map(_destination).toList();
  return Uri.https('www.google.com', '/maps/dir/', {
    'api': '1',
    'destination': legs.last,
    if (legs.length > 1)
      'waypoints': legs.sublist(0, legs.length - 1).join('|'),
    'travelmode': 'driving',
  });
}

Uri? callUri(DeliveryStop s) =>
    s.contactPhone == null ? null : Uri(scheme: 'tel', path: s.contactPhone);
