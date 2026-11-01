import 'package:cached_network_image/cached_network_image.dart';
import 'package:drs_core/drs_core.dart';
import 'package:flutter/material.dart';

/// Tells [DrsNetworkImage] which backend origin relative media paths belong
/// to. Apps put one above their router (`MaterialApp.builder`).
class DrsMedia extends InheritedWidget {
  const DrsMedia({
    required this.apiBaseUrl,
    required super.child,
    super.key,
    this.enabled = true,
  });

  final String apiBaseUrl;

  /// Widget tests turn network images off (no HTTP, no disk cache plugin).
  final bool enabled;

  static DrsMedia? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DrsMedia>();

  @override
  bool updateShouldNotify(DrsMedia old) =>
      old.apiBaseUrl != apiBaseUrl || old.enabled != enabled;
}

/// A network image that resolves server-relative paths, is cached on disk
/// (survives restarts; no re-download on every scroll) and is decoded at its
/// display size (less memory, smoother lists). Shows [placeholder] while
/// loading and on any error — never a broken-image glyph.
class DrsNetworkImage extends StatelessWidget {
  const DrsNetworkImage({
    required this.url,
    required this.placeholder,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.semanticLabel,
  });

  final String? url;
  final Widget placeholder;
  final double? width;
  final double? height;
  final BoxFit fit;

  /// null = decorative (excluded from the semantics tree).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final media = DrsMedia.maybeOf(context);
    final resolved = media == null || !media.enabled
        ? null
        : resolveMediaUrl(url, media.apiBaseUrl);
    if (resolved == null) return placeholder;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    int? px(double? logical) =>
        logical == null || !logical.isFinite ? null : (logical * dpr).round();
    final image = CachedNetworkImage(
      imageUrl: resolved,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: px(width),
      memCacheHeight: width == null ? px(height) : null,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
    return semanticLabel == null
        ? ExcludeSemantics(child: image)
        : Semantics(image: true, label: semanticLabel, child: image);
  }
}
