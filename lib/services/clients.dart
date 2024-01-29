import 'package:dio/dio.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/client_tag_filter.dart';
import 'package:mml_admin/models/connection_settings.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/api.dart';
import 'package:mml_admin/services/secure_storage.dart';

/// Service that handles the clients data of the server.
class ClientService {
  /// Instance of the client service.
  static final ClientService _instance = ClientService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

  /// Private constructor of the service.
  ClientService._();

  /// Returns the singleton instance of the [ClientService].
  static ClientService getInstance() {
    return _instance;
  }

  /// Returns a list of clients with the amount of [take] that match the given
  /// [filter] starting from the [offset].
  Future<ModelList> getClients(
    String? filter,
    int? offset,
    int? take,
    ClientTagFilter? tagfilter,
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
      '/identity/client/list',
      queryParameters: params,
      data: tagfilter != null ? tagfilter.toJson() : {},
      options: Options(
        method: 'POST',
      ),
    );

    return ModelList(
      List<Client>.from(
        response.data['items'].map((item) => Client.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Deletes the clients with the given [clientIds] on the server.
  Future<void> deleteClients<String>(List<String> clientIds) async {
    await _apiService.request(
      '/identity/client/deleteList',
      data: clientIds,
      options: Options(
        method: 'POST',
        contentType: Headers.jsonContentType,
      ),
    );
  }

  /// Updates the given [Client] on the server.
  Future<void> updateClient(Client client) async {
    await _apiService.request(
      '/identity/client',
      data: client.toJson(),
      options: Options(
        method: 'POST',
      ),
    );
  }

  /// Loads the client with the given [id] from the server.
  ///
  /// Returns the [Client] instance or null if the client was not found.
  Future<Client> getClient(String id) async {
    var response = await _apiService.request(
      '/identity/client/$id',
      options: Options(
        method: 'GET',
      ),
    );

    return Client.fromJson(response.data);
  }

  /// Loads the connection settings for a client app.
  Future<ConnectionSettings> getConnectionSettings() async {
    var response = await _apiService.request(
      '/identity/client/connection_settings',
      options: Options(
        method: 'GET',
      ),
    );

    response.data['serverName'] = await SecureStorageService.getInstance().get(
      SecureStorageService.serverNameStorageKey,
    );

    return ConnectionSettings.fromJson(response.data);
  }

  /// Assigns clients to groups.
  Future assignClients(List<String> clients, List<String> groups) async {
    await _apiService.request(
      '/identity/client/assign',
      data: {
        "items": clients,
        "groups": groups,
      },
      options: Options(
        method: 'POST',
        contentType: Headers.jsonContentType,
      ),
    );
  }
}
