import 'package:flutter/material.dart';
import 'package:mml_admin/views/login.dart';

class RouterService {
  static final RouterService _instance = RouterService();

  static RouterService getInstance() {
    return _instance;
  }

  Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      LoginScreen.route: (context) => LoginScreen()
    };
  }

  String getInitialRoute() {
    return LoginScreen.route;
  }
}
