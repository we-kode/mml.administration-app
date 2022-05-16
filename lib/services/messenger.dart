import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

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

  String get badCertificate {
    return AppLocalizations.of(snackbarKey.currentContext!)!.badCertificate;
  }

  String unexpectedError(String message) {
    return AppLocalizations.of(snackbarKey.currentContext!)!
        .unexpectedError(message);
  }

  String get forbidden {
    return AppLocalizations.of(snackbarKey.currentContext!)!.forbidden;
  }

  String get incorrectCredentials {
    return AppLocalizations.of(snackbarKey.currentContext!)!
        .incorrectCredentials;
  }
}
