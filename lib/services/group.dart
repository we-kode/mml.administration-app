import 'package:dio/dio.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/api.dart';

/// Service that handles the groups data of the server.
class GroupService {
  /// Instance of the group service.
  static final GroupService _instance = GroupService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

  /// Private constructor of the service.
  GroupService._();

  /// Returns the singleton instance of the [GroupService].
  static GroupService getInstance() {
    return _instance;
  }

  /// Returns a list of groups with the amount of [take] that match the given
  /// [filter] starting from the [offset].
  Future<ModelList> getGroups(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/identity/group',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
      options: Options(
        method: 'GET',
      ),
    );

    return ModelList(
      List<Group>.from(
        response.data['items'].map((item) => Group.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Returns a list of groups in the media service with the amount of [take]
  /// that match the given [filter] starting from the [offset].
  Future<ModelList> getMediaGroups(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/media/group',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
      options: Options(
        method: 'GET',
      ),
    );

    return ModelList(
      List<Group>.from(
        response.data['items'].map((item) => Group.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Deletes the groups with the given [groupIds] on the server.
  Future<void> deleteGroups<String>(List<String> groupIds) async {
    await _apiService.request(
      '/identity/group/deleteList',
      data: groupIds,
      options: Options(
        method: 'POST',
        contentType: Headers.jsonContentType,
      ),
    );
  }

  /// Updates the given [Group] on the server.
  Future<void> updateGroup(Group group) async {
    await _apiService.request(
      '/identity/group/${group.id}',
      data: group.toJson(),
      options: Options(
        method: 'POST',
      ),
    );
  }

  /// Creates the given [Group] on the server.
  Future<void> createGroup(Group group) async {
    await _apiService.request(
      '/identity/group',
      data: group.toJson(),
      options: Options(
        method: 'POST',
      ),
    );
  }

  /// Loads the group with the given [id] from the server.
  Future<Group> getGroup(String id) async {
    var response = await _apiService.request(
      '/identity/group/$id',
      options: Options(
        method: 'GET',
      ),
    );

    return Group.fromJson(response.data);
  }
}
