import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/models/app_update_status.dart';
import 'package:mml_admin/services/app_update.dart';
import 'package:mml_admin/view_models/app_update.dart';
import 'package:mml_admin/view_models/main.dart';

class _FakeUpdateService implements AppUpdateService {
  _FakeUpdateService(this.tag);

  final String tag;
  final requests = <Uri>[];
  String? downloaded;
  File? opened;
  Completer<void>? release;
  int failingDownloads = 0;

  @override
  Future<Map<String, dynamic>> getRelease(Uri uri) async {
    requests.add(uri);
    await release?.future;
    return {'tag_name': tag, 'body': 'changes'};
  }

  @override
  Future<File> download(Uri uri, String fileName) async {
    if (failingDownloads > 0) {
      failingDownloads--;
      throw const SocketException('offline');
    }
    downloaded = fileName;
    return File(fileName);
  }

  @override
  Future<void> openInstaller(File file) async => opened = file;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() {
    MainViewModel.repository = 'we-kode/mml.administration-app';
    MainViewModel.fileName = 'mml_admin';
  });
  tearDown(() {
    MainViewModel.repository = '';
    MainViewModel.fileName = '';
  });

  test('offers a newer release and installs it', () async {
    final service = _FakeUpdateService('1.2.0');
    final vm = AppUpdateViewModel('1.1.9', service: service);

    await vm.check();

    expect(vm.status, AppUpdateStatus.available);
    expect(vm.latestVersion, '1.2.0');
    expect(vm.changelog, 'changes');

    await vm.startUpdate();

    expect(service.downloaded, startsWith('mml_admin-1.2.0'));
    expect(service.opened, isNotNull);
    expect(vm.status, AppUpdateStatus.dismissed);
  });

  test('stays quiet for the same or an older release', () async {
    for (final tag in ['1.1.9', '1.0.12', 'v1.1.9']) {
      final vm = AppUpdateViewModel('1.1.9', service: _FakeUpdateService(tag));
      await vm.check();
      expect(vm.status, AppUpdateStatus.upToDate, reason: tag);
    }
  });

  test('rejects an invalid release tag', () async {
    final service = _FakeUpdateService('../1.2.0');
    final vm = AppUpdateViewModel('1.1.9', service: service);

    await vm.check();
    await vm.startUpdate();

    expect(vm.status, AppUpdateStatus.error);
    expect(service.downloaded, isNull);
  });

  test('skips the check without a configured repository', () async {
    MainViewModel.repository = '';
    final service = _FakeUpdateService('9.0.0');
    final vm = AppUpdateViewModel('1.1.9', service: service);

    await vm.check();

    expect(vm.status, AppUpdateStatus.upToDate);
    expect(service.requests, isEmpty);
  });

  test('ignores results after the view model is disposed', () async {
    final service = _FakeUpdateService('1.2.0')..release = Completer();
    final vm = AppUpdateViewModel('1.1.9', service: service);

    final check = vm.check();
    vm.dispose();
    service.release!.complete();

    await expectLater(check, completes);
  });

  test('offers the download again after it failed', () async {
    final service = _FakeUpdateService('1.2.0')..failingDownloads = 1;
    final vm = AppUpdateViewModel('1.1.9', service: service);
    await vm.check();

    await vm.startUpdate();

    expect(vm.status, AppUpdateStatus.downloadFailed);
    expect(service.opened, isNull);

    await vm.startUpdate();

    expect(service.opened, isNotNull);
    expect(vm.status, AppUpdateStatus.dismissed);
  });
}
