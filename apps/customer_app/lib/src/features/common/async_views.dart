import 'package:drs_api/drs_api_session.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Loading / error / data switch for an [AsyncValue] with a retry action.
class AsyncBody<T> extends StatelessWidget {
  const AsyncBody({
    required this.value,
    required this.builder,
    required this.onRetry,
    super.key,
    this.errorTitle = 'Something went wrong',
    this.loadingMessage,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback onRetry;
  final String errorTitle;
  final String? loadingMessage;

  @override
  Widget build(BuildContext context) => switch (value) {
    AsyncValue(:final T value, hasValue: true) => builder(value),
    AsyncValue(:final error?) => DrsEmptyState.error(
      title: errorTitle,
      message: errorMessage(error),
      onAction: onRetry,
    ),
    _ => DrsLoading(message: loadingMessage),
  };
}

String errorMessage(Object error) =>
    error is DrsApiError ? error.message : 'Please try again.';

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Runs [action], showing a snackbar for API errors instead of throwing.
Future<bool> runWithSnack(
  BuildContext context,
  Future<void> Function() action, {
  String? success,
}) async {
  try {
    await action();
    if (success != null && context.mounted) showSnack(context, success);
    return true;
  } on DrsApiError catch (e) {
    if (context.mounted) showSnack(context, e.message);
    return false;
  }
}
