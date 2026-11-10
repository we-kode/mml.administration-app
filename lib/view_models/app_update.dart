import 'package:flutter/foundation.dart';
import 'package:mml_admin/models/app_update_status.dart';
import 'package:mml_admin/services/app_update.dart';
import 'package:mml_admin/view_models/main.dart';

/// View model that checks for a newer release of the app, downloads it and
/// starts its installer.
class AppUpdateViewModel extends ChangeNotifier {
  static final _version = RegExp(
    r'^v?(\d+)\.(\d+)\.(\d+)([-+][0-9A-Za-z.-]+)?$',
  );

  final AppUpdateService _service;
  bool _disposed = false;

  /// The version of the running app.
  final String currentVersion;

  /// The latest released version or null if not loaded yet.
  String? latestVersion;

  /// The changelog of the [latestVersion].
  String changelog = '';

  /// The current [AppUpdateStatus].
  AppUpdateStatus status = AppUpdateStatus.checking;

  /// Initializes the view model for the app in the [currentVersion]. A custom
  /// [service] can be passed for tests.
  AppUpdateViewModel(this.currentVersion, {AppUpdateService? service})
    : _service = service ?? AppUpdateService.getInstance();

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Loads the latest release and its changelog and sets the [status]
  /// whether an update is available.
  Future<void> check() async {
    if (MainViewModel.repository.isEmpty) {
      return _setStatus(AppUpdateStatus.upToDate);
    }

    _setStatus(AppUpdateStatus.checking);
    try {
      final latest = await _service.getRelease(
        Uri.parse(MainViewModel.latestVersionUri),
      );
      final version = latest['tag_name'] as String?;
      if (version == null || !_isNewer(version, currentVersion)) {
        return _setStatus(AppUpdateStatus.upToDate);
      }

      final release = await _service.getRelease(
        Uri.parse('${MainViewModel.changeLogUri}${version.split('-').first}'),
      );
      latestVersion = version;
      changelog = release['body'] as String? ?? '';
      _setStatus(AppUpdateStatus.available);
    } catch (_) {
      _setStatus(AppUpdateStatus.error);
    }
  }

  /// Hides the available update until the next start of the app.
  void dismiss() => _setStatus(AppUpdateStatus.dismissed);

  /// Downloads the installer of the [latestVersion] and opens it. A failed
  /// download sets the [status] to [AppUpdateStatus.downloadFailed].
  Future<void> startUpdate() async {
    if (status != AppUpdateStatus.available &&
        status != AppUpdateStatus.downloadFailed) {
      return;
    }

    _setStatus(AppUpdateStatus.downloading);
    final file = '${MainViewModel.fileName}-$latestVersion';
    try {
      final installer = await _service.download(
        Uri.parse(
          '${MainViewModel.binaryUri}$latestVersion/$file${MainViewModel.extension}',
        ),
        '$file${MainViewModel.extension}',
      );
      await _service.openInstaller(installer);
      _setStatus(AppUpdateStatus.dismissed);
    } catch (_) {
      _setStatus(AppUpdateStatus.downloadFailed);
    }
  }

  void _setStatus(AppUpdateStatus value) {
    if (_disposed) {
      return;
    }
    status = value;
    notifyListeners();
  }

  static bool _isNewer(String latest, String current) {
    final l = _version.firstMatch(latest);
    final c = _version.firstMatch(current);
    if (l == null || c == null) {
      throw FormatException('Invalid version', latest);
    }
    for (var i = 1; i <= 3; i++) {
      final diff = int.parse(l.group(i)!) - int.parse(c.group(i)!);
      if (diff != 0) {
        return diff > 0;
      }
    }
    return false;
  }
}
