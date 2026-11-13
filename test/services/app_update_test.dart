import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/services/app_update.dart';

void main() {
  late HttpServer server;
  late Uri uri;

  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    uri = Uri.parse('http://${server.address.host}:${server.port}');
    server.listen((request) async {
      if (request.uri.path == '/broken') {
        request.response.contentLength = 10;
        request.response.add([1, 2, 3]);
        await request.response.flush();
        await server.close(force: true);
        return;
      }
      if (request.uri.path == '/installer') {
        request.response.add([1, 2, 3]);
      } else {
        request.response.statusCode = HttpStatus.notFound;
      }
      await request.response.close();
    });
  });

  tearDown(() => server.close(force: true));

  test('downloads the installer into its own temporary folder', () async {
    final file = await AppUpdateService.getInstance().download(
      uri.resolve('/installer'),
      'mml_admin-1.2.0.msix',
    );
    addTearDown(() => file.parent.delete(recursive: true));

    expect(await file.readAsBytes(), [1, 2, 3]);
    expect(file.parent.path, isNot(Directory.systemTemp.path));
    expect(file.parent.path, contains('mml_update_'));
  });

  int updateFolders() => Directory.systemTemp
      .listSync()
      .where((e) => e.path.contains('mml_update_'))
      .length;

  test('keeps nothing when the server rejects the download', () async {
    final before = updateFolders();

    await expectLater(
      AppUpdateService.getInstance().download(
        uri.resolve('/missing'),
        'mml_admin-1.2.0.msix',
      ),
      throwsA(isA<HttpException>()),
    );

    expect(updateFolders(), before);
  });

  test('keeps no partial file when the connection breaks', () async {
    const fileName = 'mml_admin-broken.msix';
    final partial = File('${Directory.systemTemp.path}/$fileName');
    addTearDown(() async {
      if (await partial.exists()) await partial.delete();
    });
    final before = updateFolders();

    await expectLater(
      AppUpdateService.getInstance().download(uri.resolve('/broken'), fileName),
      throwsA(anything),
    );

    expect(updateFolders(), before);
    expect(await partial.exists(), isFalse);
  });
}
