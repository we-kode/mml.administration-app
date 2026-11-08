import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/services/api.dart';
import 'package:mml_admin/services/clients.dart';
import 'package:mml_admin/services/secure_storage.dart';

/// Api, which answers all requests with the [data].
class _Api extends Fake implements ApiService {
  final Map<String, dynamic> data;

  _Api(this.data);

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
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: this.data as T,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      SecureStorageService.serverNameStorageKey: 'old.example.com',
    });
  });

  group('connection settings', () {
    test('use the server announced by the server', () async {
      final service = ClientService.withApi(
        _Api({'apiKey': 'key', 'serverName': 'new.example.com'}),
      );

      final settings = await service.getConnectionSettings();

      expect(settings.serverName, 'new.example.com');
      expect(settings.apiKey, 'key');
    });

    test('use the server of the admin app without announcement', () async {
      final service = ClientService.withApi(
        _Api({'apiKey': 'key', 'serverName': null}),
      );

      final settings = await service.getConnectionSettings();

      expect(settings.serverName, 'old.example.com');
    });
  });
}
