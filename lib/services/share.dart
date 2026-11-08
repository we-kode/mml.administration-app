import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/record_folder.dart';
import 'package:mml_admin/models/share_link.dart';
import 'package:mml_admin/models/share_options.dart';
import 'package:mml_admin/models/share_response.dart';
import 'package:mml_admin/models/share_rule.dart';
import 'package:mml_admin/models/share_settings.dart';
import 'package:mml_admin/services/api.dart';
import 'package:mml_admin/services/secure_storage.dart';

/// Service that creates share links and handles their settings and rules.
class ShareService {
  /// Instance of the share service.
  static final ShareService _instance = ShareService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService;

  /// Instance of the [SecureStorageService] the local defaults are stored in.
  final SecureStorageService _storage = SecureStorageService.getInstance();

  /// Private constructor of the service.
  ShareService._([ApiService? apiService])
    : _apiService = apiService ?? ApiService.getInstance();

  /// Creates a service, that accesses the server with the [apiService].
  @visibleForTesting
  factory ShareService.withApi(ApiService apiService) {
    return ShareService._(apiService);
  }

  /// Returns the singleton instance of the [ShareService].
  static ShareService getInstance() {
    return _instance;
  }

  /// Checks whether the server supports share links. Servers without share
  /// links answer with not found.
  Future<bool> isSupported() async {
    try {
      await getSettings();
    } on DioException catch (e) {
      return e.response?.statusCode != HttpStatus.notFound;
    }

    return true;
  }

  /// Loads the options used as defaults for new share links.
  Future<ShareOptions> loadDefaults() async {
    var hours = int.tryParse(
      await _storage.get(SecureStorageService.shareValidForHoursStorageKey) ??
          '',
    );
    var singleUse = await _storage.get(
      SecureStorageService.shareSingleUseStorageKey,
    );

    return ShareOptions(
      validForHours: ShareOptions.validForHoursChoices.contains(hours)
          ? hours!
          : ShareOptions.validForHoursChoices.last,
      singleUse: singleUse?.toLowerCase() != 'false',
    );
  }

  /// Whether share links are created with the defaults without asking.
  Future<bool> useDefaults() async {
    return (await _storage.get(
          SecureStorageService.shareUseDefaultsStorageKey,
        ))?.toLowerCase() ==
        'true';
  }

  /// Saves the [options] as defaults and whether they are used without asking.
  Future<void> saveDefaults(ShareOptions options, bool useDefaults) async {
    await _storage.set(
      SecureStorageService.shareValidForHoursStorageKey,
      options.validForHours.toString(),
    );
    await _storage.set(
      SecureStorageService.shareSingleUseStorageKey,
      options.singleUse.toString(),
    );
    await _storage.set(
      SecureStorageService.shareUseDefaultsStorageKey,
      useDefaults.toString(),
    );
  }

  /// Creates a share link for the records with the [recordIds] and within the
  /// [folders].
  Future<ShareResponse> create({
    required List<String> recordIds,
    required List<RecordFolder> folders,
    required ShareOptions options,
  }) async {
    var response = await _apiService.request(
      '/media/share',
      data: {
        'records': recordIds,
        'folders': folders.map((e) => e.toJson()).toList(),
        'validForHours': options.validForHours,
        'singleUse': options.singleUse,
      },
      options: Options(method: 'POST', contentType: Headers.jsonContentType),
    );
    var serverName = await _storage.get(
      SecureStorageService.serverNameStorageKey,
    );

    return ShareResponse(
      url: 'https://$serverName/media/s/download/${response.data['token']}',
      shared: response.data['shared'],
      skipped: response.data['skipped'],
    );
  }

  /// Loads the active share links of the current admin.
  Future<List<ShareLink>> getLinks() async {
    var response = await _apiService.request(
      '/media/share/links',
      options: Options(method: 'GET'),
    );

    return List<ShareLink>.from(
      (response.data as List).map((e) => ShareLink.fromJson(e)),
    );
  }

  /// Deletes the share link with the [id], so it can not be used anymore.
  Future<void> deleteLink(String id) async {
    await _apiService.request(
      '/media/share/$id',
      options: Options(method: 'DELETE'),
    );
  }

  /// Loads the server settings that control the share links of clients.
  Future<ShareSettings> getSettings() async {
    var response = await _apiService.request(
      '/media/share/settings',
      options: Options(method: 'GET'),
    );

    return ShareSettings.fromJson(response.data);
  }

  /// Saves the server settings that control the share links of clients.
  Future<void> saveSettings(ShareSettings settings) async {
    await _apiService.request(
      '/media/share/settings',
      data: settings.toJson(),
      options: Options(method: 'POST', contentType: Headers.jsonContentType),
    );
  }

  /// Loads a list of share rules filtered by [filter] with given [offset].
  Future<ModelList> getRules(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/media/shareRule',
      queryParameters: {
        'filter': ?filter,
        'skip': ?offset?.toString(),
        'take': ?take?.toString(),
      },
      options: Options(method: 'GET'),
    );

    return ModelList(
      List<ShareRule>.from(
        response.data['items'].map((item) => ShareRule.fromJson(item)),
      ),
      offset ?? 0,
      response.data['totalCount'],
    );
  }

  /// Loads the share rule with the given [id].
  Future<ShareRule> getRule(String id) async {
    var response = await _apiService.request(
      '/media/shareRule/$id',
      options: Options(method: 'GET'),
    );

    return ShareRule.fromJson(response.data);
  }

  /// Creates or updates the [rule].
  Future<void> saveRule(ShareRule rule) async {
    await _apiService.request(
      '/media/shareRule',
      data: rule.toRequest(),
      options: Options(method: 'POST', contentType: Headers.jsonContentType),
    );
  }

  /// Removes the share rules with the given [ids].
  Future<void> deleteRules(List<String> ids) async {
    await _apiService.request(
      '/media/shareRule/deleteList',
      data: ids,
      options: Options(method: 'POST', contentType: Headers.jsonContentType),
    );
  }
}
