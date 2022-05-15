import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/secure_storage.dart';
import 'package:mml_admin/services/user.dart';

class ApiService {
  static final ApiService _instance = ApiService._();
  final Dio _dio = Dio();
  final MessengerService _messenger = MessengerService.getInstance();
  final SecureStorageService _store = SecureStorageService.getInstance();

  ApiService._() {
    _initDio(_dio, true);
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

  void _initDio(Dio dio, bool addErrorHandling) {
    _addRequestOptionsInterceptor(dio);

    if (addErrorHandling) {
      _addDefaultErrorHandlerInterceptor(dio);
      _initClientBadCertificateCallback(dio);
    }
  }

  void _addRequestOptionsInterceptor(Dio dio) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        var serverName = await _store.get(SecureStorageService.serverNameStorageKey);

        options.baseUrl = 'https://$serverName/api/v1.0/';
        options.headers['Accept-Language'] = Platform.localeName;

        var accessToken = await _store.get(SecureStorageService.accessTokenStorageKey);

        if (accessToken != null) {
          options.headers['Authorization'] = "Bearer $accessToken";
        }

        var appKey = await _store.get(SecureStorageService.appKeyStorageKey);

        if (appKey != null) {
          options.headers['App-Key'] = appKey;
        }

        return handler.next(options);
      }
    ));
  }

  void _addDefaultErrorHandlerInterceptor(Dio dio) {
    dio.interceptors.add(QueuedInterceptorsWrapper(
      onError: (DioError e, handler) async {
        if (e.response != null) {
          var statusCode = e.response!.statusCode;
          if (statusCode == HttpStatus.unauthorized) {
            RequestOptions requestOptions = e.requestOptions;

            if (await _store.has(SecureStorageService.refreshTokenStorageKey)) {
              await _refreshToken();

              if (!(await _store.has(SecureStorageService.refreshTokenStorageKey))) {
                // Logout was called, since token incorrect or expired!
                return handler.reject(e);
              }

              // Retry request with the new token.
              var retryDio = Dio();
              _initDio(retryDio, true);

              var options = Options(
                method: requestOptions.method,
                contentType: requestOptions.contentType,
                headers: requestOptions.headers
              );

              try {
                var retryResponse = await retryDio.request(
                  requestOptions.path,
                  cancelToken: requestOptions.cancelToken,
                  onReceiveProgress: requestOptions.onReceiveProgress,
                  options: options,
                  data: requestOptions.data,
                  queryParameters: requestOptions.queryParameters
                );

                return handler.resolve(retryResponse);
              } catch (e) {
                return handler.reject(e as DioError);
              }
            }

            // Unauthorized on login page, must be handled extra!
            _messenger.showMessage(_messenger.incorrectCredentials);
            return handler.reject(e);
          } else if (statusCode == HttpStatus.forbidden) {
            _messenger.showMessage(_messenger.forbidden);
            return handler.reject(e);
          } else if (statusCode != null && statusCode >= HttpStatus.badRequest && statusCode < HttpStatus.internalServerError) {
            // Client errors should be handled by the specific widget!
            return handler.reject(e);
          }
        }

        // All other errors except certificate errors!
        if (e.type is! HandshakeException) {
          _messenger.showMessage(_messenger.unexpectedError(e.message));
        }

        return handler.reject(e);
      }
    ));
  }

  void _initClientBadCertificateCallback(Dio dio) {
    DefaultHttpClientAdapter httpClient = dio.httpClientAdapter as DefaultHttpClientAdapter;
    httpClient.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        if (!kDebugMode) {
          _messenger.showMessage(_messenger.badCertificate);
        }
        return kDebugMode;
      };

      return client;
    };
  }

  Future _refreshToken() async {
    var dio = Dio();
    _initDio(dio, false);

    try {
      var clientId = await _store.get(SecureStorageService.clientIdStorageKey);
      var refreshToken = await _store.get(SecureStorageService.refreshTokenStorageKey);

      Response response = await dio.request(
        "/identity/connect/token",
        data: {
          "grant_type": "refresh_token",
          "client_id": clientId,
          "refresh_token": refreshToken,
          "scope": "offline_access"
        },
        options: Options(
          method: 'POST',
          contentType: Headers.formUrlEncodedContentType
        )
      );

      if (response.statusCode == HttpStatus.ok) {
        _store.set(SecureStorageService.accessTokenStorageKey, response.data?['access_token']);
        _store.set(SecureStorageService.refreshTokenStorageKey, response.data?['refresh_token']);
      } else {
        // TODO: Relogin message
        await UserService.getInstance().logout();
      }
    } catch (e) {
      // TODO: Relogin message
      await UserService.getInstance().logout();
    }
  }
}
