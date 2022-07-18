import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mml_admin/extensions/multipartfile.dart';
import 'package:mml_admin/services/api.dart';

/// Service that handles the records data of the server.
class RecordService {
  /// Instance of the record service.
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

  /// Uploads a [file] with the given [fileName] to the server.
  Future upload(File file, String fileName) async {
    final lastModified = await file.lastModified();
    FormData formData = FormData.fromMap(
      {
        "file": MultipartFileExtended.fromFileSync(
          file.path,
          filename: fileName,
        )
      },
    );
    formData.fields.add(
      MapEntry(
        'LastModifiedDate',
        lastModified.toString(),
      ),
    );
    await _apiService.request(
      '/media/upload',
      data: formData,
      options: Options(method: 'POST'),
    );
  }
}
