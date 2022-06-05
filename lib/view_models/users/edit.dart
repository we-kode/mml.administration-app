import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/user.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/user.dart';
import 'package:mml_admin/services/router.dart';

///
class UsersEditDialogViewModel extends ChangeNotifier {
  ///
  final UserService _userService = UserService.getInstance();

  /// Current build context.
  late BuildContext _context;

  /// User model for creationd or modification.
  late User user;

  /// Locales of the application.
  late AppLocalizations locales;

  ///
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ///
  bool userLoadedSuccessfully = false;

  Map<String, List<String>> errors = {};

  ///
  Future<bool> init(BuildContext context, int? userId) async {
    locales = AppLocalizations.of(context)!;
    _context = context;

    if (userId == null) {
      return Future.microtask(() {
        user = User();
        userLoadedSuccessfully = true;
        notifyListeners();
        return true;
      });
    }

    try {
      user = await _userService.getUser(userId);
      userLoadedSuccessfully = true;
      notifyListeners();
    } catch (e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        var messenger = MessengerService.getInstance();

        messenger.showMessage(messenger.notFound);
      }

      Navigator.pop(context, true);
      return false;
    }

    return true;
  }

  ///
  String get passwordLabel {
    return user.id != null && (user.password ?? '').isEmpty
        ? locales.passwordUnchanged
        : locales.password;
  }

  /// Validates the given [username] and returns an error message or null if
  /// the name is valid.
  String? validateUsername(String? username) {
    var error = (username ?? '').isNotEmpty ? null : locales.invalidUsername;

    return _addBackendErrors('Name', error);
  }

  /// Validates the given [password] and returns an error message or null if
  /// the password is valid.
  String? validatePassword(String? password) {
    var error = (password ?? '').isNotEmpty || user.id != null
        ? null
        : locales.invalidPassword;

    return _addBackendErrors('Password', error);
  }

  set password(String? password) {
    user.password = password;
  }

  clearBackendErrors(String fieldName) {
    errors.remove(fieldName);
    notifyListeners();
  }

  ///
  void saveUser() async {
    var nav = Navigator.of(_context);

    showProgressIndicator();

    if (!userLoadedSuccessfully || !formKey.currentState!.validate()) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      return;
    }

    formKey.currentState!.save();

    var shouldClose = false;

    try {
      await (user.id != null
          ? _userService.updateUser(user)
          : _userService.createUser(user));
      shouldClose = true;
    } catch (e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        var messenger = MessengerService.getInstance();

        messenger.showMessage(messenger.notFound);
      } else if (e is DioError &&
          e.response?.statusCode == HttpStatus.badRequest) {
        errors = ((e.response!.data as Map)['errors'] as Map).map((key, value) {
          return MapEntry(key.toString(), List<String>.from(value));
        });
        formKey.currentState!.validate();
      }
    } finally {
      RouterService.getInstance().navigatorKey.currentState!.pop();

      if (shouldClose) {
        nav.pop(true);
      }
    }
  }

  String? _addBackendErrors(String fieldName, String? error) {
    if (errors.containsKey(fieldName) && errors[fieldName]!.isNotEmpty) {
      error = (error != null ? '$error\n' : '');
      error += errors[fieldName]!.join("\n");
    }

    return error;
  }
}
