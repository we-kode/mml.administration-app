import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/models/model_list.dart';
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
  Future<ModelList> getUsers(String? filter, int? offset, int? take) async {
    Map<String, dynamic> queryParameters = {};

    if ((filter ?? '').isNotEmpty) {
      queryParameters['filter'] = filter;
    }

    if (offset != null) {
      queryParameters['skip'] = offset;
    }

    if (take != null) {
      queryParameters['take'] = take;
    }

    var response = await _apiService.request(
      '/identity/user/list',
      queryParameters: queryParameters,
      options: Options(
        method: 'GET',
      ),
    );

    return ModelList(
      List<User>.from(
        response.data['items'].map((item) => User.fromJson(item)),
      ),
      offset ?? 0,
      response.data['totalCount'],
    );
  }

  /// Loads the user with the given [id] from the server.
  ///
  /// Returns the [User] instance or null if the user was not found.
  Future<User> getUser(int id) async {
    var response = await _apiService.request(
      '/identity/user/$id',
      options: Options(
        method: 'GET',
      ),
    );

    return User.fromJson(response.data);
  }

  /// Deletes the users with the given [userIds] on the server.
  Future<void> deleteUsers<int>(List<int> userIds) async {
    await _apiService.request(
      '/identity/user/deleteList',
      data: userIds,
      options: Options(method: 'POST'),
    );
  }

  /// Creates the given [User] on the server.
  Future<void> createUser(User user) async {
    await _apiService.request(
      '/identity/user/create',
      data: user.toJson(),
      options: Options(method: 'POST', contentType: Headers.jsonContentType),
    );
  }

  /// Updates the given [User] on the server.
  Future<void> updateUser(User user) async {
    // Sent null for empty password to prevent change!
    user.password = (user.password ?? '').isNotEmpty ? user.password : null;

    await _apiService.request(
      '/identity/user${user.id == null ? '' : '/${user.id}'}',
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
