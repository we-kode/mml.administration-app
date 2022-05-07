import 'package:dio/dio.dart';
import 'package:mml_admin/services/secure_storage.dart';

class ApiService {
  static final ApiService _instance = ApiService._();
  final Dio _dio = Dio();

  ApiService._() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        var serverName = await SecureStorageService.getInstance().get(SecureStorageService.serverNameStorageKey);

        options.baseUrl = 'https://$serverName/api/v1.0/';
        // TODO (headers):
        //  - Set accept language
        //  - Set Bearer token
        //  - Set app key

        // options.headers.

        return handler.next(options);
      }
      // TODO: Handle responses, also to get a new token if current expired
    ));
  }

  static ApiService getInstance() {
    return _instance;
  }

  Future<Response<T>> request<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.request<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress
    );
  }
}
