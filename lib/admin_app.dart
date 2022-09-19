import 'package:flutter/material.dart';
import 'package:mml_admin/lib_color_schemes.g.dart';
import 'package:mml_admin/services/messenger.dart';
import 'services/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

/// Administration application for My Media Lib.
class AdminApp extends StatelessWidget {
  /// Initializes the instance.
  const AdminApp({Key? key}) : super(key: key);

  /// Creates the app with the necessary configurations.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,

      // Specify key for the snackbar at the bottom of the app.
      scaffoldMessengerKey: MessengerService.getInstance().snackbarKey,

      // Configure theme data.
      theme: ThemeData(colorScheme: lightColorScheme),
      darkTheme: ThemeData(colorScheme: darkColorScheme),
      themeMode: ThemeMode.system,

      // Configure the main navigator of the app.
      navigatorKey: RouterService.getInstance().navigatorKey,
      initialRoute: RouterService.getInstance().initialRoute,
      routes: RouterService.getInstance().routes,

      // Configure the localizations of the app.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('de', ''),
        Locale('ru', ''),
      ],
    );
  }
}
