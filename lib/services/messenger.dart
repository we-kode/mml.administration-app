import 'package:flutter/material.dart';

class MessengerService {
  final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey();
  static final MessengerService _instance = MessengerService._();

  MessengerService._();

  static MessengerService getInstance() {
    return _instance;
  }

  showMessage(String text) {
    final SnackBar snackBar = SnackBar(content: Text(text));
    snackbarKey.currentState?.showSnackBar(snackBar);
  }
}
