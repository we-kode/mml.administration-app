import 'package:dio/dio.dart';
import 'package:mml_admin/services/api.dart';

class RecordService {
  /// Instance of the group service.
  static final RecordService _instance = RecordService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

  /// Private constructor of the service.
  RecordService._();

  /// Returns the singleton instance of the [RecordService].
  static RecordService getInstance() {
    return _instance;
  }

  /// Loads the compression rate.
  Future<String> getCompressionRate() async {
    var response = await _apiService.request(
      '/media/settings/compressionRate',
      options: Options(
        method: 'GET',
      ),
    );

    return response.data;
  }
}