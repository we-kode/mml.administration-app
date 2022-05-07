import 'package:flutter/material.dart';

showProgressIndicator(BuildContext context) {
  AlertDialog indicatorDialog = AlertDialog(
    content: ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 64,
        minHeight: 64,
      ),
      child: const CircularProgressIndicator()
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return indicatorDialog;
    },
  );
}
