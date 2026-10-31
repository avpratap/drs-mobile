import 'package:drs_api/drs_api_session.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';

String errorMessage(Object error) =>
    error is DrsApiError ? error.message : 'Please try again.';

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// The state for a failed load: offline (wifi-off, connection advice),
/// not found (no retry), or an error with "Try again".
Widget errorState(
  Object error, {
  required String title,
  VoidCallback? onRetry,
}) => switch (error) {
  DrsApiError(isConnectivity: true) => DrsEmptyState.offline(
    title: title,
    onAction: onRetry,
  ),
  DrsApiError(kind: DrsApiErrorKind.notFound) => DrsEmptyState(
    icon: Icons.search_off,
    title: title,
    message: 'It may have been removed from your route.',
  ),
  _ => DrsEmptyState.error(
    title: title,
    message: errorMessage(error),
    onAction: onRetry,
  ),
};
