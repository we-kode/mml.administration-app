import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/secure_storage.dart';

class ApiService {
  static final ApiService _instance = ApiService._();
  final Dio _dio = Dio();

  ApiService._() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        var serverName = await SecureStorageService.getInstance().get(SecureStorageService.serverNameStorageKey);

        options.baseUrl = 'https://$serverName/api/v1.0/';
        options.headers['Accept-Language'] = Platform.localeName;

        var accessToken = await SecureStorageService.getInstance().get(SecureStorageService.accessTokenStorageKey);

        if (accessToken != null) {
          options.headers['Authorization'] = "Bearer $accessToken";
        }

        var appKey = await SecureStorageService.getInstance().get(SecureStorageService.appKeyStorageKey);

        if (appKey != null) {
          options.headers['App-Key'] = appKey;
        }

        return handler.next(options);
      }
    ));
    _dio.interceptors.add(QueuedInterceptorsWrapper(
      onError: (DioError e, handler) async {
        if (e.response != null) {
          if (e.response!.statusCode == 401) {
            RequestOptions requestOptions = e.requestOptions;

            await _refreshToken();

          }
        }

        MessengerService.getInstance().showMessage("An unknown error occured!");

        return handler.reject(e);
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

  Future _refreshToken() async {
    // TODO: Send request for a new refresh token either with current or new dio instance
    // and persist the gotten token
  }
}
