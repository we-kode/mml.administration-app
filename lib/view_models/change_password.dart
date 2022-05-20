import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/main.dart';

import '../models/user.dart';
import '../services/router.dart';

/// View model of the change password screen.
class ChangePasswordViewModel extends ChangeNotifier {
  /// Route of the change password screen.
  static String route = '/change_password';

  /// Current user passed to this route after successfull login.
  late User user;

  /// Initialize the change password view model.
  Future<bool> init(BuildContext context) async {
    return Future<bool>.microtask(() async {
      user = ModalRoute.of(context)!.settings.arguments as User;

      // Redirect to main page, if the logged in user is confirmed.
      if (user.isConfirmed == true) {
        RouterService.getInstance()
            .navigatorKey
            .currentState!
            .pushReplacementNamed(
              MainViewModel.route,
              arguments: user,
            );
        return false;
      }

      return true;
    });
  }
}
