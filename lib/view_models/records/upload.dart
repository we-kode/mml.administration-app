import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mime/mime.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/record_validation.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/record.dart';

/// ViewModel of the uplaod dialog for records.
class RecordsUploadDialogViewModel extends ChangeNotifier {
  /// Locales of the application.
  late AppLocalizations locales;

  /// [RecordService] used to load data for the records uplaod dialog.
  final RecordService _service = RecordService.getInstance();

  /// [GroupService] used to load data for the groups of the client editing
  /// screen.
  final GroupService _groupService = GroupService.getInstance();

  /// Number of files to be uploaded.
  int fileCount = 0;

  /// Number of files already uploaded.
  int uploadedFiles = 0;

  /// Name of the file which is uploading.
  String uploadingFileName = '';

  /// List with files, which were not uploaded due errors.
  Map<String, List<String>> notUploadedFiles = {};

  /// Groups to which the uploaded records will be added.
  List<Group> selectedGroups = [];

  /// [UploadProcessState] of the current process.
  UploadProcessState _state = UploadProcessState.groups;

  /// Folder to be uploaded or null if only files will be uploaded.
  late String? folder;

  /// Files to be uploaded or null if folder will be uploaded.
  late List<PlatformFile>? files;

  /// validation settings
  late RecordValidation _recordValidation;

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
    notUploadedFiles = {};
    folder = folderPath;
    files = fileList;
    return Future<bool>.microtask(
      () async {
        _recordValidation = await _service.getValidationSettings();
        if (_state == UploadProcessState.upload) {
          initUpload();
        } else if (_state == UploadProcessState.groups) {
          final groups = List<Group>.from(await getGroups());
          selectedGroups =
              groups.where((element) => element.isDefault).toList();
        }
        return true;
      },
    );
  }

  /// Loads all groups from the server.
  Future<ModelList> getGroups() async {
    return await _groupService.getGroups(null, 0, -1);
  }

  /// Determines whether to upload files or folder and start uploading.
  Future initUpload() async {
    _state = UploadProcessState.upload;
    notifyListeners();
    (folder ?? '').isNotEmpty ? _uploadFolder(folder!) : _uploadFiles(files!);
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
      // validate file before upload
      if (!(await _recordValidation.isValid(uploadingFileName, file))) {
        notUploadedFiles.addAll({
          uploadingFileName: _recordValidation.validationErrors,
        });
      } else {
        await _service.upload(
          file,
          uploadingFileName,
          selectedGroups.map((e) => e.id!).toList(),
        );
      }
      uploadedFiles++;
      notifyListeners();
    } on DioException catch (e) {
      notUploadedFiles.addAll({
        uploadingFileName: List.from(["uploadValidFailed"]),
      });
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

  /// Returns the current [state] of the upload process.
  UploadProcessState get state {
    return _state;
  }

  /// Returns localized strings of validation erros.
  String localizeError(String key) {
    switch (key) {
      case RecordValidationErrors.language:
        return locales.uploadInvalidLanguage;
      case RecordValidationErrors.album:
        return locales.uploadInvalidAlbum;
      case RecordValidationErrors.albums:
        return locales.uploadInvalidAlbums;
      case RecordValidationErrors.artist:
        return locales.uploadInvalidArtist;
      case RecordValidationErrors.cover:
        return locales.uploadInvalidCover;
      case RecordValidationErrors.filename:
        return locales.uploadInvalidFilenameFormat;
      case RecordValidationErrors.genre:
        return locales.uploadInvalidGenre;
      case RecordValidationErrors.genres:
        return locales.uploadInvalidGenres;
      case RecordValidationErrors.title:
        return locales.uploadInvalidTitle;
      case RecordValidationErrors.number:
        return locales.uploadInvalidNumber;
      default:
        return locales.uploadValidFailed;
    }
  }
}

/// State of the upload process.
enum UploadProcessState {
  groups,
  upload,
  success,
}
