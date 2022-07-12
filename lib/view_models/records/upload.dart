import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mime/mime.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/record.dart';

/// ViewModel of the uplaod dialog for records.
class RecordsUploadDialogViewModel extends ChangeNotifier {
  /// Key of the upload form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  /// [RecordService] used to load data for the records uplaod dialog.
  final RecordService _service = RecordService.getInstance();

  /// Number of files to be uplaoded.
  int fileCount = 0;

  /// Number of files already uploaded.
  int uploadedFiles = 0;

  /// Name of the file which is uploading.
  String uploadingFileName = '';

  /// Initializes the ViewModel and starts the uplaod process.
  ///
  /// If no [folderPath] is provided, files from the [fileList] will be uploaded, else
  /// all files from the [folderPath] will be uploaded recursive.
  Future<bool> init(
    BuildContext context,
    String? folderPath,
    List<PlatformFile>? fileList,
  ) async {
    locales = AppLocalizations.of(context)!;
    _context = context;
    return Future<bool>.microtask(
      () {
        (folderPath ?? '').isNotEmpty
            ? _uploadFolder(folderPath!)
            : _uploadFiles(fileList!);
        return true;
      },
    );
  }

  /// Uploads all file given in the [folderPath]. All files in subfolders will be uplaoded also.
  Future _uploadFolder(String folderPath) async {
    final nav = Navigator.of(_context);
    final files = await Directory(folderPath).list(recursive: true).toList();
    fileCount = files
        .where(
          (element) => element is File && _isMp3(element),
        )
        .length;
    for (var element in files) {
      if (element is File) {
        await _upload(element);
      }
    }
    nav.pop(true);
  }

  /// Uplaods all files in the [fileList].
  Future _uploadFiles(List<PlatformFile> fileList) async {
    final nav = Navigator.of(_context);
    fileCount = fileList.length;
    for (var element in fileList) {
      var file = File(element.name);
      await _upload(file);
    }
    nav.pop(true);
  }

  /// Uplaods the given [file].
  Future _upload(File file) async {
    if (!_isMp3(file)) {
      return;
    }
    try {
      uploadedFiles++;
      uploadingFileName = file.path.split(Platform.pathSeparator).last;
      await _service.upload(file, uploadingFileName);
      notifyListeners();
    } catch (e) {
      if (e is DioError &&
          e.response?.statusCode == HttpStatus.requestEntityTooLarge) {
        var messenger = MessengerService.getInstance();
        messenger.showMessage(messenger.fileToLarge);
      }
    }
  }

  /// Checks if [file] is a mp3 file.
  bool _isMp3(File file) {
    final mimeType = lookupMimeType(file.path);
    return mimeType == 'audio/mpeg';
  }
}
