import 'package:dio/dio.dart';
import 'package:mml_admin/models/announcement.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/api.dart';

/// Service to manage the announcements shown to the clients.
class AnnouncementService {
  /// Instance of the announcement service.
  static final AnnouncementService _instance = AnnouncementService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

  /// Private constructor of the service.
  AnnouncementService._();

  /// Returns the singleton instance of the [AnnouncementService].
  static AnnouncementService getInstance() {
    return _instance;
  }

  /// Loads a list of announcements filtered by [filter] with given [offset].
  Future<ModelList> get(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/media/notification/list',
      queryParameters: {
        'filter': ?filter,
        'skip': ?offset?.toString(),
        'take': ?take?.toString(),
      },
      options: Options(method: 'GET'),
    );

    return ModelList(
      List<Announcement>.from(
        response.data['items'].map((item) => Announcement.fromJson(item)),
      ),
      offset ?? 0,
      response.data['totalCount'],
    );
  }

  /// Loads the announcement with the given [id].
  Future<Announcement> getAnnouncement(String id) async {
    var response = await _apiService.request(
      '/media/notification/$id',
      options: Options(method: 'GET'),
    );

    return Announcement.fromJson(response.data);
  }

  /// Creates or updates the [announcement].
  Future<void> update(Announcement announcement) async {
    await _apiService.request(
      '/media/notification',
      data: announcement.toJson(),
      options: Options(method: 'POST'),
    );
  }

  /// Removes the announcements with the given [ids].
  Future<void> delete(List<String> ids) async {
    await _apiService.request(
      '/media/notification/deleteList',
      data: ids,
      options: Options(method: 'POST', contentType: Headers.jsonContentType),
    );
  }
}
