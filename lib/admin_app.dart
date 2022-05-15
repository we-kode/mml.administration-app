import 'package:flutter/material.dart';
import 'package:mml_admin/lib_color_schemes.g.dart';
import 'package:mml_admin/services/messenger.dart';
import 'services/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
      scaffoldMessengerKey: MessengerService.getInstance().snackbarKey,
      navigatorKey: RouterService.getInstance().navigatorKey,
      theme: ThemeData(
        colorScheme: lightColorScheme
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme
      ),
      themeMode: ThemeMode.system,
      initialRoute: RouterService.getInstance().getInitialRoute(),
      routes: RouterService.getInstance().getRoutes(),
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
