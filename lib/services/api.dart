import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mml_admin/extensions/multipartfile.dart';
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
        options.headers['Accept-Language'] =
            Intl.shortLocale(Platform.localeName);

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
      InterceptorsWrapper(onError: (DioException e, handler) async {
        if (e.response != null) {
          var statusCode = e.response!.statusCode;
          if (statusCode == HttpStatus.unauthorized) {
            RequestOptions requestOptions = e.requestOptions;

            if (await _store.has(SecureStorageService.refreshTokenStorageKey)) {
              await UserService.getInstance().refreshToken();

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
                  data: requestOptions.data is FormData
                      ? _reinitFormData(requestOptions.data)
                      : requestOptions.data,
                  queryParameters: requestOptions.queryParameters,
                );

                return handler.resolve(retryResponse);
              } catch (e) {
                return handler.reject(e as DioException);
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
          _messenger.showMessage(_messenger.unexpectedError(e.message ?? ""));
        }

        return handler.reject(e);
      }),
    );
  }

  /// Reinitialize the form data when token was refreshed.
  FormData _reinitFormData(data) {
    FormData formData = FormData();
    formData.fields.addAll(data.fields);
    for (MapEntry mapFile in data.files) {
      formData.files.add(
        MapEntry(
          mapFile.key,
          MultipartFileExtended.fromFileSync(
            mapFile.value.filePath,
            filename: mapFile.value.filename,
          ),
        ),
      );
    }
    return formData;
  }
}
