import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/login.dart';
import 'package:mml_admin/views/login.dart';

class RouterService {
  static final RouterService _instance = RouterService();

  static RouterService getInstance() {
    return _instance;
  }

  Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      LoginViewModel.route: (context) => const LoginScreen()
    };
  }

  String getInitialRoute() {
    return LoginViewModel.route;
  }
}
