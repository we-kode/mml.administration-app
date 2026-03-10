// Service that handles the instance data of the server.
import 'package:dio/dio.dart';
import 'package:mml_admin/services/api.dart';

class InstanceService {
  /// Instance of the instance service.
  static final InstanceService _instance = InstanceService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

  /// Private constructor of the service.
  InstanceService._();

  /// Returns the singleton instance of the [InstanceService].
  static InstanceService getInstance() {
    return _instance;
  }

  /// Loads the instance data from the server.
  ///
  /// Returns the instance data.
  Future<String> get() async {
    var response = await _apiService.request(
      '/identity/instance',
      options: Options(
        method: 'GET',
      ),
    );

    return response.data;
  }
}
