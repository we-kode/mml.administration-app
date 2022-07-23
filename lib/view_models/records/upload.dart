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
  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  /// [RecordService] used to load data for the records uplaod dialog.
  final RecordService _service = RecordService.getInstance();

  /// Number of files to be uploaded.
  int fileCount = 0;

  /// Number of files already uploaded.
  int uploadedFiles = 0;

  /// Name of the file which is uploading.
  String uploadingFileName = '';

  /// Initializes the ViewModel and starts the upload process.
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
  }

  /// Uploads all files in the [fileList].
  Future _uploadFiles(List<PlatformFile> fileList) async {
    fileCount = fileList.length;
    for (var element in fileList) {
      var file = File(element.path!);
      await _upload(file);
    }
  }

  /// Uplaods the given [file].
  Future _upload(File file) async {
    if (!_isMp3(file)) {
      return;
    }
    try {
      uploadingFileName = file.path.split(Platform.pathSeparator).last;
      notifyListeners();
      await _service.upload(file, uploadingFileName);
      uploadedFiles++;
      notifyListeners();
    } on DioError catch (e) {
      if (e.response?.statusCode == HttpStatus.requestEntityTooLarge) {
        var messenger = MessengerService.getInstance();
        messenger.showMessage(messenger.fileToLarge(uploadingFileName));
        return;
      }

      if (e.response?.statusCode == HttpStatus.badRequest) {
        var messenger = MessengerService.getInstance();
        var uploadError = "";
        final errorData = e.response?.data;
        if (errorData is String) {
          if (errorData == 'INVALID_FORMAT_MP3') {
            uploadError = locales.invalidMp3File;
          } else if (errorData == 'INVALID_FILE_EMPTY') {
            uploadError = locales.invalidFileNoContent;
          }
        }
        messenger.showMessage(
          messenger.uploadingFileFailed(
            uploadingFileName,
            uploadError,
          ),
        );
        return;
      }
    }
  }

  /// Checks if [file] is a mp3 file.
  bool _isMp3(File file) {
    final mimeType = lookupMimeType(file.path);
    return mimeType == 'audio/mpeg';
  }
}
