import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/clients.dart';
import 'package:mml_admin/view_models/login.dart';
import 'package:mml_admin/view_models/records.dart';
import 'package:mml_admin/view_models/settings.dart';
import 'package:mml_admin/view_models/users.dart';
import 'package:mml_admin/views/clients.dart';
import 'package:mml_admin/views/login.dart';
import 'package:mml_admin/view_models/main.dart';
import 'package:mml_admin/views/main.dart';
import 'package:mml_admin/views/records.dart';
import 'package:mml_admin/views/settings.dart';
import 'package:mml_admin/views/users.dart';

class RouterService {
  static final RouterService _instance = RouterService();

  /// Navigator key for the nested pages.
  final nestedNavigatorKey = GlobalKey<NavigatorState>();

  static RouterService getInstance() {
    return _instance;
  }

  Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      LoginViewModel.route: (context) => const LoginScreen(),
      MainViewModel.route: (context) => const MainScreen(),
    };
  }

  String getInitialRoute() {
    return LoginViewModel.route;
  }

  /// Neted routes which can be reached by the navigation.
  Map<String, Route<dynamic>?> getNestedRoutes() {
    return {
      RecordsViewModel.route:
          MaterialPageRoute(builder: (_) => const RecordsScreen()),
      ClientsViewModel.route:
          MaterialPageRoute(builder: (_) => const ClientsScreen()),
      UsersViewModel.route:
          MaterialPageRoute(builder: (_) => const UsersScreen()),
      SettingsViewModel.route:
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
    };
  }
}
