import 'package:drs_api/drs_api_session.dart';
import 'package:flutter/material.dart';

String errorMessage(Object error) =>
    error is DrsApiError ? error.message : 'Please try again.';

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
