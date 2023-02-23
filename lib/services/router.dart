import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/change_password.dart';
import 'package:mml_admin/view_models/clients/overview.dart';
import 'package:mml_admin/view_models/groups/overview.dart';
import 'package:mml_admin/view_models/login.dart';
import 'package:mml_admin/view_models/records/overview.dart';
import 'package:mml_admin/view_models/settings/settings.dart';
import 'package:mml_admin/view_models/users/overview.dart';
import 'package:mml_admin/views/change_password.dart';
import 'package:mml_admin/views/clients/overview.dart';
import 'package:mml_admin/views/groups/overview.dart';
import 'package:mml_admin/views/login.dart';
import 'package:mml_admin/view_models/main.dart';
import 'package:mml_admin/views/main.dart';
import 'package:mml_admin/views/records/overview.dart';
import 'package:mml_admin/views/settings/settings.dart';
import 'package:mml_admin/views/users/overview.dart';

/// Service that holds all routing information of the navigators of the app.
class RouterService {
  /// Instance of the router service.
  static final RouterService _instance = RouterService._();

  /// GlobalKey of the state of the main navigator.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// Private constructor of the service.
  RouterService._();

  /// Returns the singleton instance of the [RouterService].
  static RouterService getInstance() {
    return _instance;
  }

  /// Routes of the main navigator.
  Map<String, Widget Function(BuildContext)> get routes {
    return {
      LoginViewModel.route: (context) => const LoginScreen(),
      ChangePasswordViewModel.route: (context) => const ChangePasswordScreen(),
      MainViewModel.route: (context) => const MainScreen(),
    };
  }

  /// Name of the initial route for the main navigation.
  String get initialRoute {
    return LoginViewModel.route;
  }

  /// Routes of the nested navigator.
  Map<String, Route<dynamic>?> get nestedRoutes {
    return {
      RecordsViewModel.route: PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const RecordsScreen(),
        transitionDuration: const Duration(seconds: 0),
      ),
      ClientsViewModel.route: PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const ClientsScreen(),
        transitionDuration: const Duration(seconds: 0),
      ),
      GroupsOverviewViewModel.route: PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            const GroupsOverviewScreen(),
        transitionDuration: const Duration(seconds: 0),
      ),
      UsersOverviewViewModel.route: PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            const UsersOverviewScreen(),
        transitionDuration: const Duration(seconds: 0),
      ),
      SettingsViewModel.route: PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            const SettingsScreen(),
        transitionDuration: const Duration(seconds: 0),
      ),
    };
  }
}
