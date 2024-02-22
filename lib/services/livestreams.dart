import 'package:dio/dio.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/livestream.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/api.dart';

class LivestreamService {
  /// Instance of the livestream service.
  static final LivestreamService _instance = LivestreamService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

  /// Private constructor of the service.
  LivestreamService._();

  /// Returns the singleton instance of the [LivestreamService].
  static LivestreamService getInstance() {
    return _instance;
  }

  /// Loads a list of livestream items filtered by [filter] with given [offset].
  Future<ModelList> get(
    String? filter,
    int? offset,
    int? take,
  ) async {
    var params = <String, String?>{};

    if (filter != null) {
      params['filter'] = filter;
    }

    if (offset != null) {
      params['skip'] = offset.toString();
    }

    if (take != null) {
      params['take'] = take.toString();
    }

    var response = await _apiService.request(
      '/media/livestream/list',
      queryParameters: params,
      options: Options(
        method: 'POST',
      ),
    );

    return ModelList(
      List<Livestream>.from(
        response.data['items'].map((item) => Livestream.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Removes all livestreams [ids].
  Future<void> delete<String>(List<String> ids) async {
    await _apiService.request(
      '/media/livestream/deleteList',
      data: ids,
      options: Options(
        method: 'POST',
        contentType: 'application/json',
      ),
    );
  }

  /// Loads stream settings of item by [id].
  Future<Livestream> getLivestream(String id) async {
    var response = await _apiService.request(
      '/media/livestream/$id',
      options: Options(
        method: 'GET',
      ),
    );

    return Livestream.fromJson(response.data);
  }

  /// Updates one livestream entry [stream].
  Future<void> update(Livestream stream) async {
    await _apiService.request(
      '/media/livestream',
      data: stream.toJson(),
      options: Options(
        method: 'POST',
      ),
    );
  }

  /// Assigns items to groups.
  Future assign(
    List<String> items,
    List<String> initGroups,
    List<String> groups,
  ) async {
    await _apiService.request(
      '/media/livestream/assign',
      data: {
        "items": items,
        "groups": groups,
        "initGroups": initGroups,
      },
      options: Options(
        method: 'POST',
        contentType: Headers.jsonContentType,
      ),
    );
  }

  /// Loads assigend groups
  Future<ModelList> assignedGroups(List<String> items) async {
    var response = await _apiService.request(
      '/media/livestream/assignedGroups',
      data: items,
      options: Options(
        method: 'POST',
        contentType: Headers.jsonContentType,
      ),
    );

    return ModelList(
      List<Group>.from(
        response.data['items'].map((item) => Group.fromJson(item)),
      ),
      0,
      response.data["totalCount"],
    );
  }
}
