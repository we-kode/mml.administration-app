import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/view_models/records/edit.dart';

final class _FakeFile extends PlatformFile {
  _FakeFile(this.bytes);

  final Uint8List bytes;

  @override
  String get name => 'cover.png';

  @override
  Uri get uri => Uri.file('cover.png');

  @override
  get xFile => throw UnimplementedError();

  @override
  int? lengthSync() => bytes.length;

  @override
  Future<int?> length() async => bytes.length;

  @override
  Future<Uint8List> readAsBytes() async => bytes;

  @override
  Stream<Uint8List> readAsByteStream() => Stream.value(bytes);
}

class _FakePicker extends FilePickerPlatform {
  _FakePicker(this.file);

  final PlatformFile? file;
  List<String>? allowedExtensions;

  @override
  Future<PlatformFile?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    this.allowedExtensions = allowedExtensions;
    return file;
  }
}

void main() {
  RecordEditViewModel createViewModel() =>
      RecordEditViewModel()
        ..locales = lookupAppLocalizations(const Locale('en'));

  test('pickCover stores the bytes of the picked image', () async {
    final bytes = Uint8List.fromList([1, 2, 3]);
    final picker = _FakePicker(_FakeFile(bytes));
    FilePickerPlatform.instance = picker;
    final vm = createViewModel()..coverRemoved = true;

    await vm.pickCover();

    expect(vm.newCover, bytes);
    expect(vm.coverRemoved, isFalse);
    expect(picker.allowedExtensions, ['jpg', 'jpeg', 'png']);
  });

  test('pickCover keeps the current cover when picking is canceled', () async {
    FilePickerPlatform.instance = _FakePicker(null);
    final vm = createViewModel()..coverRemoved = true;

    await vm.pickCover();

    expect(vm.newCover, isNull);
    expect(vm.coverRemoved, isTrue);
  });
}
