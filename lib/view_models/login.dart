import 'package:flutter/material.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/extensions/is_valid_guid.dart';
import 'package:mml_admin/route_arguments/change_password.dart';
import 'package:mml_admin/services/secure_storage.dart';
import 'package:mml_admin/services/user.dart';
import 'package:mml_admin/models/user.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/view_models/change_password.dart';

/// View model of the login screen.
class LoginViewModel extends ChangeNotifier {
  /// Key of the app persisted in the secure storage.
  late String? _persistedAppKey;

  /// Id of the client persisted in the secure storage.
  late String? _persistedClientId;

  /// Name of the server persisted in the secure storage.
  late String? _persistedServerName;

  /// Current build context.
  late BuildContext _context;

  /// [SecureStorageService] used to load data from the secure storage.
  final SecureStorageService _storage = SecureStorageService.getInstance();

  /// [UserService] used to login and load data of the current user.
  final UserService _userService = UserService.getInstance();

  /// Username set in the field of the login form.
  String? username;

  /// Password set in the field of the login form.
  String? password;

  /// The app key.
  String? appKey;

  /// The id of the client.
  String? clientId;

  /// Name of the server.
  String? serverName;

  /// Locales of the application.
  late AppLocalizations locales;

  /// Global key of the login form.
  ///
  /// Is used to call validate and save on the form.
  final formKey = GlobalKey<FormState>();

  /// Route of the login screen.
  static String route = '/login';

  /// Tries to load user data with the stored credentials.
  ///
  /// If this is possible the data of the current [User] will be returned.
  /// Otherwise an empty [User] model will be returned, to show the login page.
  /// Also the persisted credentials will be loaded from the secure storage.
  Future<User> init(BuildContext context) async {
    _context = context;
    locales = AppLocalizations.of(_context)!;

    return Future<User>.microtask(() async {
      User? user;

      try {
        user = await _userService.getUserInfo();
      } catch (e) {
        // Catch all errors and do nothing, since handled by api service!
      }

      // Load maybe persisted keys from secure storage.
      _persistedAppKey = await _storage.get(
        SecureStorageService.appKeyStorageKey,
      );
      _persistedClientId = await _storage.get(
        SecureStorageService.clientIdStorageKey,
      );
      _persistedServerName = await _storage.get(
        SecureStorageService.serverNameStorageKey,
      );

      // Create an empty user if not logged in, otherwhise the snapshot would
      // not have any data and would not show login screen.
      return user ?? User();
    });
  }

  /// Tries to login with the given credentials.
  ///
  /// On success the user data gets load from the server and will be passed
  /// to the [ChangePasswordScreen], where the user is redirected. Otherwise
  /// the corresponding error message will be shown in the message bar.
  void login() async {
    if (formKey.currentState!.validate()) {
      showProgressIndicator();
      formKey.currentState!.save();

      // Store the passed client informations if changed by the user.
      if ((appKey ?? '').isNotEmpty) {
        await _storage.set(
          SecureStorageService.appKeyStorageKey,
          appKey,
        );
      }

      if ((clientId ?? '').isNotEmpty) {
        await _storage.set(
          SecureStorageService.clientIdStorageKey,
          clientId,
        );
      }

      if ((serverName ?? '').isNotEmpty) {
        await _storage.set(
          SecureStorageService.serverNameStorageKey,
          serverName,
        );
      }

      // Try to login with given credentials.
      try {
        await _userService.login(username!, password!);
        User? user = await _userService.getUserInfo();

        // Redirect to changepassword screen, if login was successfull.
        if (user != null) {
          RouterService.getInstance().navigatorKey.currentState!.pop();
          await afterLogin(user);
        }
      } catch (e) {
        // Catch all errors and do nothing, since handled by api service!
        RouterService.getInstance().navigatorKey.currentState!.pop();
      }
    }
  }

  /// Redirects the logged in [user] to the [ChangePasswordScreen].
  Future afterLogin(User user) async {
    await RouterService.getInstance()
        .navigatorKey
        .currentState!
        .pushReplacementNamed(
          ChangePasswordViewModel.route,
          arguments: ChangePasswordArguments(user),
        );
  }

  /// Validates the given [username] and returns an error message or null if
  /// the name is valid.
  String? validateUsername(String? username) {
    return (username ?? '').isNotEmpty ? null : locales.invalidUsername;
  }

  /// Validates the given [password] and returns an error message or null if
  /// the password is valid.
  String? validatePassword(String? password) {
    return (password ?? '').isNotEmpty ? null : locales.invalidPassword;
  }

  /// Validates the given [appKey] and returns an error message or null if
  /// the key is valid.
  ///
  /// If the [appKey] is empty the persisted key will be used, if there is
  /// one. When a persisted key is given, a empty [appKey] is will be still
  /// valid.
  String? validateAppKey(String? appKey) {
    if ((appKey ?? '').isEmpty && (_persistedAppKey ?? '').isNotEmpty) {
      appKey = _persistedAppKey;
    }

    return (appKey ?? '').isValidGuid() ? null : locales.invalidAppKey;
  }

  /// Validates the given [clientId] and returns an error message or null if
  /// the id is valid.
  ///
  /// If the [clientId] is empty the persisted id will be used, if there is
  /// one. When a persisted id is given, a empty [clientId] is will be still
  /// valid.
  String? validateClientId(String? clientId) {
    if ((clientId ?? '').isEmpty && (_persistedClientId ?? '').isNotEmpty) {
      clientId = _persistedClientId;
    }

    return (clientId ?? '').isValidGuid() ? null : locales.invalidClientId;
  }

  /// Validates the given [serverName] and returns an error message or null if
  /// the name is valid.
  ///
  /// If the [serverName] is empty the persisted name will be used, if there is
  /// one. When a persisted name is given, a empty [serverName] will be still
  /// valid.
  String? validateServerName(String? serverName) {
    if ((serverName ?? '').isEmpty && (_persistedServerName ?? '').isNotEmpty) {
      serverName = _persistedServerName;
    }

    return (serverName ?? '').isNotEmpty ? null : locales.invalidServerName;
  }

  /// Label for the app key input field.
  ///
  /// If a app key is persisted in the secure storage, the label will defer
  /// from the normal label.
  String get appKeyLabel {
    return (_persistedAppKey ?? '').isNotEmpty && (appKey ?? '').isEmpty
        ? locales.appKeyUnchanged
        : locales.appKey;
  }

  /// Label for the client id input field.
  ///
  /// If a client id is persisted in the secure storage, the label will defer
  /// from the normal label.
  String get clientIdLabel {
    return (_persistedClientId ?? '').isNotEmpty && (clientId ?? '').isEmpty
        ? locales.clientIdUnchanged
        : locales.clientId;
  }

  /// Label for the servername input field.
  ///
  /// If a servername is persisted in the secure storage, the label will defer
  /// from the normal label.
  String get serverNameLabel {
    return (_persistedServerName ?? '').isNotEmpty && (serverName ?? '').isEmpty
        ? locales.serverNameUnchanged
        : locales.serverName;
  }

  /// Determines if the advanced settings on the login screen will be inital expanded or collapsed.
  bool get showAdvanced {
    return (_persistedAppKey ?? '').isEmpty || (_persistedClientId ?? '').isEmpty || (_persistedServerName ?? '').isEmpty;
  }
}
