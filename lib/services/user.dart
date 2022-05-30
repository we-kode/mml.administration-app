import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/models/user.dart';
import 'package:mml_admin/services/api.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/secure_storage.dart';
import 'package:mml_admin/view_models/login.dart';

/// Service that handles the admin user data of the server.
class UserService {
  /// Instance of the user service.
  static final UserService _instance = UserService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

  /// Instance of the [SecureStorageService] to handle data in the secure
  /// storage.
  final SecureStorageService _storage = SecureStorageService.getInstance();

  /// Private constructor of the service.
  UserService._();

  /// Returns the singleton instance of the [UserService].
  static UserService getInstance() {
    return _instance;
  }

  /// Returns a list of users with the amount of [take] that match the given
  /// [filter] starting from the [offset].
  Future<List<User>> getUsers(String? filter, int? offset, int? take) async {
    throw UnimplementedError();
  }

  /// Loads the user with the given [id] from the server.
  ///
  /// Returns the [User] instance or null if the user was not found.
  Future<User?> getUser(int id) async {
    throw UnimplementedError();
  }

  /// Deletes the user with the given [id] on the server.
  Future<void> deleteUser(int id) async {
    throw UnimplementedError();
  }

  /// Creates the given [User] on the server.
  Future<void> createUser(User user) async {
    throw UnimplementedError();
  }

  /// Updates the given [User] on the server.
  Future<void> updateUser(User user) async {
    await _apiService.request(
      '/identity/user',
      data: user.toJson(),
      options: Options(method: 'POST', contentType: Headers.jsonContentType),
    );
  }

  /// Tries to login with the given [username] and [password].
  ///
  /// If the login is successfully the returned tokens gets persisted to the
  /// secure storage.
  Future login(String username, String password) async {
    var clientId = await _storage.get(SecureStorageService.clientIdStorageKey);

    Response<Map> response = await _apiService.request(
      '/identity/connect/token',
      data: {
        'grant_type': 'password',
        'client_id': clientId,
        'scope': 'offline_access',
        'username': username,
        'password': password
      },
      options: Options(
        method: 'POST',
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      await _storage.set(
        SecureStorageService.accessTokenStorageKey,
        response.data?['access_token'],
      );
      await _storage.set(
        SecureStorageService.refreshTokenStorageKey,
        response.data?['refresh_token'],
      );
    }
  }

  /// Logs the current user out, deletes the tokens from the secure storage
  /// and redirects the user to the login page.
  Future logout() async {
    try {
      // Use new dio instance without error handling to avoid endless logout
      // loop.
      var dio = Dio();
      _apiService.initDio(dio, false);

      await dio.request(
        '/identity/connect/logout',
        data: {},
        options: Options(
          method: 'POST',
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
    } catch (e) {
      // Ignore all errors, since logout will always be done by expiration of
      // tokens.
    } finally {
      // Delete the tokens from the storage.
      await _storage.delete(SecureStorageService.accessTokenStorageKey);
      await _storage.delete(SecureStorageService.refreshTokenStorageKey);

      // Redirect the user to the login screen.
      NavigatorState state =
          RouterService.getInstance().navigatorKey.currentState!;
      state.pushReplacementNamed(LoginViewModel.route);
    }
  }

  /// Returns the current logged in [User] or null.
  Future<User?> getUserInfo() async {
    if (await _storage.has(SecureStorageService.accessTokenStorageKey)) {
      var response = await _apiService.request(
        '/identity/connect/userinfo',
        options: Options(method: 'GET'),
      );
      var user = User.fromJson(response.data);
      return user;
    }

    return null;
  }
}
