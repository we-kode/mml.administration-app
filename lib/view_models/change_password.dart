import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/main.dart';

import '../models/user.dart';
import '../services/router.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  static String route = '/change_password';
  late User user;

  Future<bool> init(BuildContext context) async {
    return Future<bool>.microtask(() async {
      user = ModalRoute.of(context)!.settings.arguments as User;

      if (user.isConfirmed == true) {

      RouterService.getInstance().navigatorKey.currentState!.pushNamed(
          MainViewModel.route,
          arguments: user,
        );
        return false;
      }

      return true;
    });
  }
}
