import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'admin_app.dart';

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
    size: const Size(1600, 1000),
    minimumSize: const Size(1600, 1000),
    center: true,
    title: appLocales.appTitle,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const AdminApp());
}
