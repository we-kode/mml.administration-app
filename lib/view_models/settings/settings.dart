import 'package:flutter/material.dart';
import 'package:mml_admin/models/user.dart';
import 'package:mml_admin/route_arguments/change_password.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/user.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/view_models/change_password.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// View model for the settings screen.
class SettingsViewModel extends ChangeNotifier {
  /// Route for the settings screen.
  static String route = '/settings';

  /// [UserService] used to load data of the current user.
  final UserService _userService = UserService.getInstance();

  /// Current user
  late User? user;

  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  /// version of the running app.
  late String version;

  /// Initialize the settings view model.
  Future<bool> init(BuildContext context) async {
    return Future<bool>.microtask(() async {
      _context = context;
      locales = AppLocalizations.of(_context)!;
      var pkgInfo = await PackageInfo.fromPlatform();
      version = pkgInfo.version;
      try {
        user = await _userService.getUserInfo();
      } catch (e) {
        // Catch all errors and do nothing, since handled by api service!
      }
      return true;
    });
  }

  /// Redirects the logged in [user] to the [ChangePasswordScreen].
  Future changePassword() async {
    await RouterService.getInstance().navigatorKey.currentState!.pushNamed(
          ChangePasswordViewModel.route,
          arguments: ChangePasswordArguments(user!, isManualTriggered: true),
        );
  }
}
