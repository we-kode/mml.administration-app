import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/services/api.dart';
import 'package:mml_admin/services/share.dart';

/// Api, which answers the settings of share links with the [status].
class _Api extends Fake implements ApiService {
  final int status;

  _Api(this.status);

  @override
  Future<Response<T>> request<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final requestOptions = RequestOptions(path: path);
    if (status == 200) {
      return Response(
        requestOptions: requestOptions,
        statusCode: status,
        data: <String, dynamic>{} as T,
      );
    }

    throw DioException(
      requestOptions: requestOptions,
      response: Response(requestOptions: requestOptions, statusCode: status),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('servers answering with not found do not support sharing', () async {
    expect(await ShareService.withApi(_Api(404)).isSupported(), isFalse);
  });

  test('other errors do not hide sharing', () async {
    expect(await ShareService.withApi(_Api(500)).isSupported(), isTrue);
  });

  test('servers with share settings support sharing', () async {
    expect(await ShareService.withApi(_Api(200)).isSupported(), isTrue);
  });
}
