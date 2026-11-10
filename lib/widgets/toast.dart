import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..clearSnackBars()
    ..showSnackBar(SnackBar(
      content: Text(message),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 104), // clears floating nav
      duration: const Duration(seconds: 3),
    ));
}
