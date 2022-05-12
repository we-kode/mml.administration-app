import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/login.dart';
import 'package:mml_admin/views/login.dart';
import 'package:mml_admin/view_models/main.dart';
import 'package:mml_admin/views/main.dart';

class RouterService {
  static final RouterService _instance = RouterService();

  static RouterService getInstance() {
    return _instance;
  }

  Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      LoginViewModel.route: (context) => const LoginScreen(),
      MainViewModel.route: (context) => const MainScreen()
    };
  }

  String getInitialRoute() {
    // return LoginViewModel.route;
    return MainViewModel.route;
  }
}
