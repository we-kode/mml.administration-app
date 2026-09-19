// Service that handles the instance data of the server.
import 'package:dio/dio.dart';
import 'package:mml_admin/services/api.dart';

class SyncService {
  /// Instance of the sync service.
  static final SyncService _instance = SyncService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

  /// Private constructor of the service.
  SyncService._();

  /// Returns the singleton instance of the [SyncService].
  static SyncService getInstance() {
    return _instance;
  }

  /// Loads the instance data from the server.
  ///
  /// Returns the instance data.
  Future<String> get() async {
    var response = await _apiService.request(
      '/media/sync/instance',
      options: Options(
        method: 'GET',
      ),
    );

    return response.data;
  }
}
