import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Service that loads release information and installers of the app.
class AppUpdateService {
  /// Instance of the app update service.
  static final AppUpdateService _instance = AppUpdateService._();

  /// Private constructor of the service.
  AppUpdateService._();

  static const _timeout = Duration(seconds: 30);

  /// Returns the singleton instance of the [AppUpdateService].
  static AppUpdateService getInstance() {
    return _instance;
  }

  /// Returns the release information found at the [uri].
  Future<Map<String, dynamic>> getRelease(Uri uri) async {
    final response = await http.get(uri).timeout(_timeout);
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('Status ${response.statusCode}', uri: uri);
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Downloads the installer from the [uri] as [fileName] into a new folder in
  /// the temporary directory. Nothing is kept if the download fails.
  Future<File> download(Uri uri, String fileName) async {
    final client = http.Client();
    final folder = await Directory.systemTemp.createTemp('mml_update_');
    try {
      final response = await client
          .send(http.Request('GET', uri))
          .timeout(_timeout);
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('Status ${response.statusCode}', uri: uri);
      }
      final file = File('${folder.path}/$fileName');
      final sink = file.openWrite();
      try {
        await sink.addStream(response.stream.timeout(_timeout));
      } finally {
        await sink.close();
      }
      return file;
    } catch (_) {
      await folder.delete(recursive: true);
      rethrow;
    } finally {
      client.close();
    }
  }

  /// Opens the downloaded installer [file] with the default application of
  /// the operating system.
  Future<void> openInstaller(File file) async {
    if (Platform.isWindows) {
      await Process.start('explorer', [file.path]);
    } else if (Platform.isMacOS) {
      await Process.start('open', [file.path]);
    } else {
      await Process.start('xdg-open', [file.parent.path]);
    }
  }
}
