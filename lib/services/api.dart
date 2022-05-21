import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/secure_storage.dart';
import 'package:mml_admin/services/user.dart';

/// Service that handles requests to the server by adding all necessary headers
/// and handles errors with interceptors, that can occur during requests.
class ApiService {
  /// Instance of the api service.
  static final ApiService _instance = ApiService._();

  /// [Dio] instance that is used to send request.
  final Dio _dio = Dio();

  /// Instance of the messenger service, to show messages with.
  final MessengerService _messenger = MessengerService.getInstance();

  /// Instance of the [SecureStorageService] to handle data in the secure
  /// storage.
  final SecureStorageService _store = SecureStorageService.getInstance();

  /// Private constructor of the service.
  ApiService._() {
    initDio(_dio, true);
  }

  /// Returns the singleton instance of the [ApiService].
  static ApiService getInstance() {
    return _instance;
  }

  /// Sends a request with the given parameters to the server.
  Future<Response<T>> request<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.request<T>(path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  /// Initializes the [dio] instance with interceptors for the default handling.
  ///
  /// Adds interceptors for error handling if [addErrorHandling] is set to true.
  void initDio(Dio dio, bool addErrorHandling) {
    _addRequestOptionsInterceptor(dio);
    _initClientBadCertificateCallback(dio);

    if (addErrorHandling) {
      _addDefaultErrorHandlerInterceptor(dio);
    }
  }

  /// Adds an interceptor to the [dio] instance, that adds all necessary headers
  /// to a request send with the passed instance.
  void _addRequestOptionsInterceptor(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) async {
        var serverName = await _store.get(
          SecureStorageService.serverNameStorageKey,
        );

        options.baseUrl = 'https://$serverName/api/v1.0/';
        options.headers['Accept-Language'] = Platform.localeName;

        var accessToken = await _store.get(
          SecureStorageService.accessTokenStorageKey,
        );

        if (accessToken != null) {
          options.headers['Authorization'] = "Bearer $accessToken";
        }

        var appKey = await _store.get(SecureStorageService.appKeyStorageKey);

        if (appKey != null) {
          options.headers['App-Key'] = appKey;
        }

        return handler.next(options);
      }),
    );
  }

  /// Adds an interceptor to the [dio] instance, that handles errors occured
  /// during requests send with the passed instance.
  void _addDefaultErrorHandlerInterceptor(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(onError: (DioError e, handler) async {
        if (e.response != null) {
          var statusCode = e.response!.statusCode;
          if (statusCode == HttpStatus.unauthorized) {
            RequestOptions requestOptions = e.requestOptions;

            if (await _store.has(SecureStorageService.refreshTokenStorageKey)) {
              await _refreshToken();

              if (!(await _store.has(
                SecureStorageService.refreshTokenStorageKey,
              ))) {
                // Logout was called, since token incorrect or expired!
                return handler.reject(e);
              }

              // Retry request with the new token.
              var retryDio = Dio();
              initDio(retryDio, true);

              var options = Options(
                method: requestOptions.method,
                contentType: requestOptions.contentType,
                headers: requestOptions.headers,
              );

              try {
                var retryResponse = await retryDio.request(
                  requestOptions.path,
                  cancelToken: requestOptions.cancelToken,
                  onReceiveProgress: requestOptions.onReceiveProgress,
                  options: options,
                  data: requestOptions.data,
                  queryParameters: requestOptions.queryParameters,
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
          } else if (statusCode != null &&
              statusCode >= HttpStatus.badRequest &&
              statusCode < HttpStatus.internalServerError) {
            // Client errors should be handled by the specific widget!
            return handler.reject(e);
          }
        }

        // All other errors except certificate errors!
        if (e.type is! HandshakeException) {
          _messenger.showMessage(_messenger.unexpectedError(e.message));
        }

        return handler.reject(e);
      }),
    );
  }

  /// Adds an error hadnler to the passed [dio] instance, to handle errors
  /// occured due to bad certificates.
  void _initClientBadCertificateCallback(Dio dio) {
    DefaultHttpClientAdapter httpClient =
        dio.httpClientAdapter as DefaultHttpClientAdapter;
    httpClient.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (
        X509Certificate cert,
        String host,
        int port,
      ) {
        // Ignore bad certificates in debug mode!
        if (!kDebugMode) {
          _messenger.showMessage(_messenger.badCertificate);
        }
        return kDebugMode;
      };

      return client;
    };
  }

  /// Tries to refresh the tokens with the credentials stored in the secure
  /// storage.
  Future _refreshToken() async {
    var dio = Dio();
    initDio(dio, false);

    try {
      // Get new tokens.
      var clientId = await _store.get(SecureStorageService.clientIdStorageKey);
      var refreshToken = await _store.get(
        SecureStorageService.refreshTokenStorageKey,
      );

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
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      // Store the tokens on successfull request.
      if (response.statusCode == HttpStatus.ok) {
        _store.set(
          SecureStorageService.accessTokenStorageKey,
          response.data?['access_token'],
        );
        _store.set(
          SecureStorageService.refreshTokenStorageKey,
          response.data?['refresh_token'],
        );
      } else {
        _messenger.showMessage(_messenger.relogin);
        await UserService.getInstance().logout();
      }
    } catch (e) {
      // Logout on errors.
      _messenger.showMessage(_messenger.relogin);
      await UserService.getInstance().logout();
    }
  }
}
