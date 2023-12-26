import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/user.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/user.dart';
import 'package:mml_admin/services/router.dart';

/// ViewModel of the create/edit dialog for users.
class UsersEditDialogViewModel extends ChangeNotifier {
  /// [UserService] that handles the requests to the server.
  final UserService _userService = UserService.getInstance();

  /// Key of the user edit form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Name of name field in the errors response.
  final String nameField = 'Name';

  /// Name of password field in the errors response.
  final String passwordField = 'Password';

  /// Current build context.
  late BuildContext _context;

  /// User model for creationd or modification.
  late User user;

  /// Locales of the application.
  late AppLocalizations locales;

  /// Flag that indicates whether the user is successful loaded.
  bool userLoadedSuccessfully = false;

  /// Map of errors from the server.
  Map<String, List<String>> errors = {};


  /// Initializes the ViewModel and loads the user with the given [userId] or
  /// creates an new user model if the id is not passed.
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
      if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
        var messenger = MessengerService.getInstance();

        messenger.showMessage(messenger.notFound);
      }

      if (context.mounted) Navigator.pop(context, true);
      return false;
    }

    return true;
  }

  /// Label for the password field.
  String get passwordLabel {
    return user.id != null && (user.password ?? '').isEmpty
        ? locales.passwordUnchanged
        : locales.password;
  }

  /// Validates the given [username] and returns an error message or null if
  /// the name is valid.
  String? validateUsername(String? username) {
    var error = (username ?? '').isNotEmpty ? null : locales.invalidUsername;

    return _addBackendErrors(nameField, error);
  }

  /// Validates the given [password] and returns an error message or null if
  /// the password is valid.
  String? validatePassword(String? password) {
    var error = (password ?? '').isNotEmpty || user.id != null
        ? null
        : locales.invalidPassword;

    return _addBackendErrors(passwordField, error);
  }

  /// Sets the passed [password] to the user.
  set password(String? password) {
    user.password = password;
    notifyListeners();
  }

  /// Clears the errors from the backend for the field with the passed
  /// [fieldName].
  clearBackendErrors(String fieldName) {
    errors.remove(fieldName);
  }

  /// Saves (creates or updates) the user and closes the user dialog on success.
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
    } on DioException catch (e) {
      var statusCode = e.response?.statusCode;

      if (statusCode == HttpStatus.notFound) {
        var messenger = MessengerService.getInstance();
        messenger.showMessage(messenger.notFound);
        shouldClose = true;
      } else if (statusCode == HttpStatus.badRequest) {
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

  /// Adds errors from backend for passed [fieldName] to the [error] string
  /// divided by new lines and returns the extended error string.
  String? _addBackendErrors(String fieldName, String? error) {
    if (errors.containsKey(fieldName) && errors[fieldName]!.isNotEmpty) {
      error = (error != null ? '$error\n' : '');
      error += errors[fieldName]!.join("\n");
    }

    return error;
  }
}
