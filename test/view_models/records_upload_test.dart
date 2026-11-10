import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/record_validation.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/record.dart';
import 'package:mml_admin/view_models/records/upload.dart';

class _ValidRecords extends RecordValidation {
  @override
  Future<bool> isValid(String fileName, File file) async => true;
}

class _FakeRecordService implements RecordService {
  final uploads = <String>[];
  final started = Completer<void>();
  CancelToken? token;

  @override
  Future<RecordValidation> getValidationSettings() async => _ValidRecords();

  @override
  Future upload(
    File file,
    String fileName,
    List<String> groups, {
    CancelToken? cancelToken,
  }) {
    uploads.add(fileName);
    token = cancelToken;
    started.complete();
    return cancelToken!.whenCancel.then((e) => throw e);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeGroupService implements GroupService {
  @override
  Future<ModelList> getGroups(String? filter, int? offset, int? take) async =>
      ModelList([], 0, 0);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('closing the dialog cancels the running upload', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
      ),
    );

    await tester.runAsync(() async {
      final folder = await Directory.systemTemp.createTemp('mml_upload_');
      addTearDown(() => folder.delete(recursive: true));
      await File('${folder.path}/a.mp3').writeAsBytes([1]);
      await File('${folder.path}/b.mp3').writeAsBytes([1]);

      final service = _FakeRecordService();
      final vm = RecordsUploadDialogViewModel(
        service: service,
        groupService: _FakeGroupService(),
      );
      await vm.init(context, folder.path, null);

      final upload = vm.initUpload();
      await service.started.future;
      vm.dispose();
      await upload;

      expect(service.token!.isCancelled, isTrue);
      expect(service.uploads, hasLength(1));
      expect(vm.uploadedFiles, 0);
      expect(vm.notUploadedFiles, isEmpty);
    });
  });
}
