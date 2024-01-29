import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/route_arguments/change_password.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/user.dart';
import 'package:mml_admin/view_models/main.dart';
import 'package:mml_admin/models/user.dart';
import 'package:mml_admin/services/router.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

/// View model of the change password screen.
class ChangePasswordViewModel extends ChangeNotifier {
  /// Route of the change password screen.
  static String route = '/change_password';

  /// [UserService] used to load data of the current user.
  final UserService _userService = UserService.getInstance();

  /// Instance of the messenger service, to show messages with.
  final MessengerService _messenger = MessengerService.getInstance();

  /// Current build context.
  late BuildContext _context;

  /// Current user passed to this route after successfull login.
  late User user;

  /// Indicates, taht the change password screen can be closed, as it has been
  /// manually triggered.
  late bool isCloseable;

  /// Locales of the application.
  late AppLocalizations locales;

  /// Global key of the change password form.
  ///
  /// Is used to call validate and save on the form.
  final formKey = GlobalKey<FormState>();

  /// The old password set in the form.
  String? actualPassword;

  /// Server side validation error for the old password.
  String? _actualPasswordError;

  /// The new entered password.
  String? newPassword;

  /// Server side validation error for the new password.
  String? _newPasswordError;

  /// The validation of right entered new password.
  String? newConfirmPassword;

  /// Initialize the change password view model.
  Future<bool> init(BuildContext context) async {
    return Future<bool>.microtask(() async {
      _context = context;
      var args =
          ModalRoute.of(context)!.settings.arguments as ChangePasswordArguments;
      user = args.user;
      isCloseable = args.isManualTriggered;
      locales = AppLocalizations.of(_context)!;

      // Redirect to main page, if the logged in user is confirmed.
      if (user.isConfirmed == true && !args.isManualTriggered) {
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

  /// Validates the given [password] and returns an error message or null if
  /// the password is valid.
  String? validateActualPassword(String? password) {
    if ((actualPassword ?? '').isEmpty) {
      return locales.invalidPassword;
    }

    if ((_actualPasswordError ?? '').isNotEmpty) {
      return _actualPasswordError;
    }

    return null;
  }

  /// Validates the given [password] and returns an error message or null if
  /// the password is valid.
  String? validateNewPassword(String? password) {
    return _validatePassword(password);
  }

  /// Validates the given [password] and returns an error message or null if
  /// the password is valid.
  String? validateConfirmPassword(String? password) {
    return _validatePassword(password);
  }

  String? _validatePassword(String? password) {
    if ((password ?? '').isEmpty) {
      return locales.invalidPassword;
    }

    if (newPassword != newConfirmPassword) {
      return locales.invalidConfirmPasswords;
    }

    if ((_newPasswordError ?? '').isNotEmpty) {
      return _newPasswordError;
    }

    return null;
  }

  /// Clears the server side validation error of the old password.
  void clearActualPasswordError() {
    _actualPasswordError = '';
  }

  /// Clears the server side validation error of the new password.
  void clearNewPasswordError() {
    _newPasswordError = '';
  }

  /// Tries to confirm new password.
  ///
  /// On success the user will be transfered to the main view.
  void confirmPassword() async {
    clearActualPasswordError();
    clearNewPasswordError();
    if (!formKey.currentState!.validate()) {
      return;
    }

    showProgressIndicator();
    formKey.currentState!.save();

    try {
      await _userService.updateUser(
        User(
          name: user.name,
          oldPassword: actualPassword,
          newPassword: newPassword,
        ),
      );
      RouterService.getInstance().navigatorKey.currentState!.pop();
      await afterConfirmation();
    } on DioException catch (e) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      var errData = e.response!;
      if (errData.data is String && errData.data == 'USER_UPDATE_FAILED') {
        _messenger.showMessage(locales.updatePasswordFailed);
        return;
      }

      if (errData.data is! Map) {
        return;
      }

      var errors = ((errData.data as Map)['errors'] as Map);
      errors.forEach((key, value) {
        switch (key) {
          case 'NewPassword':
            _newPasswordError = value[0];
            break;
          case 'OldPassword':
            _actualPasswordError = value[0];
            break;
        }
        formKey.currentState!.validate();
      });
    } catch (e) {
      // other errors will be handled by api service or else
    }
  }

  /// Redirects to the [MainScreen].
  Future afterConfirmation() async {
    await RouterService.getInstance()
        .navigatorKey
        .currentState!
        .pushReplacementNamed(MainViewModel.route);
  }

  /// Returns to calling screen.
  void cancel() {
    RouterService.getInstance().navigatorKey.currentState!.pop();
  }
}
