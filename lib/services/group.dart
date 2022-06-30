import 'package:dio/dio.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/api.dart';

class GroupService {
  static final GroupService _instance = GroupService._();

  final ApiService _apiService = ApiService.getInstance();

  GroupService._();

  static GroupService getInstance() {
    return _instance;
  }

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

  Future<void> deleteGroups<String>(List<String> groupIds) async {
    await _apiService.request(
      '/identity/group/deleteList',
      data: groupIds,
      options: Options(
        method: 'POST',
      ),
    );
  }

  Future<void> updateGroup(Group group) async {
    await _apiService.request(
      '/identity/group/${group.id}',
      data: group.toJson(),
      options: Options(
        method: 'POST',
      ),
    );
  }

  Future<void> createGroup(Group group) async {
    await _apiService.request(
      '/identity/group',
      data: group.toJson(),
      options: Options(
        method: 'POST',
      ),
    );
  }

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
