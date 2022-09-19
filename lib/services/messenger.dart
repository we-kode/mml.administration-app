import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

/// Service that shows messages in the snackbar of the app.
class MessengerService {
  /// Instance of the messenger service.
  static final MessengerService _instance = MessengerService._();

  /// Global key to access the state of the snackbar.
  final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey();

  /// Private constructor of the service.
  MessengerService._();

  /// Returns the singleton instance of the [MessengerService].
  static MessengerService getInstance() {
    return _instance;
  }

  /// Translated string for a message if a record is not found.
  String get notFound {
    return AppLocalizations.of(snackbarKey.currentContext!)!.notFound;
  }

  /// Shows the given [text] in the app snackbar.
  showMessage(String text) {
    final SnackBar snackBar = SnackBar(content: Text(text));
    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  /// Translated string for bad certificate errors.
  String get badCertificate {
    return AppLocalizations.of(snackbarKey.currentContext!)!.badCertificate;
  }

  /// Returns the translated string for unexpected errors with the passed
  /// [message].
  String unexpectedError(String message) {
    return AppLocalizations.of(snackbarKey.currentContext!)!
        .unexpectedError(message);
  }

  /// Translated string for forbidden errors.
  String get forbidden {
    return AppLocalizations.of(snackbarKey.currentContext!)!.forbidden;
  }

  /// Translated string for incorrect credentials errors.
  String get incorrectCredentials {
    return AppLocalizations.of(snackbarKey.currentContext!)!
        .incorrectCredentials;
  }

  /// Translated string for a message if the user gets automatically logged out.
  String get relogin {
    return AppLocalizations.of(snackbarKey.currentContext!)!.relogin;
  }

  /// Translated string for to large file errors for [fileName].
  String fileToLarge(String fileName) {
    return AppLocalizations.of(snackbarKey.currentContext!)!
        .toLargeFile(fileName);
  }

  /// Translated string for [error] accured on [fileName].
  String uploadingFileFailed(String fileName, String error) {
    return AppLocalizations.of(snackbarKey.currentContext!)!
        .uploadingFileFailed(fileName, error);
  }
}
