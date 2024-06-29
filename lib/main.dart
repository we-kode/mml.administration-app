import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:window_manager/window_manager.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'admin_app.dart';

class MMLHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (
        X509Certificate cert,
        String host,
        int port,
      ) {
        // Ignore bad certificates in debug mode!
        if (kReleaseMode) {
          final messenger = MessengerService.getInstance();
          messenger.showMessage(messenger.badCertificate);
        }
        return !kReleaseMode;
      };
  }
}

/// Runs the admin application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await findSystemLocale();

  var systemLocale = Locale(Intl.systemLocale);
  var locale = AppLocalizations.delegate.isSupported(systemLocale)
      ? systemLocale
      : AppLocalizations.supportedLocales.first;

  var appLocales = await AppLocalizations.delegate.load(locale);

  WindowOptions windowOptions = WindowOptions(
    size: const Size(1600, 900),
    minimumSize: const Size(1600, 900),
    center: true,
    title: appLocales.appTitle,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  HttpOverrides.global = MMLHttpOverrides();
  runApp(const AdminApp());
}
