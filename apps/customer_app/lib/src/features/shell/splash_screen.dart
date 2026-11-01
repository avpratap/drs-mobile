import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';

/// Continues the native launch screen (deep green, on-dark lockup) while the
/// session is restored, so there's no colour flash on start.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const DrsBrandSplash();
}
