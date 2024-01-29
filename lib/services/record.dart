import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mml_admin/extensions/multipartfile.dart';
import 'package:mml_admin/models/album.dart';
import 'package:mml_admin/models/artist.dart';
import 'package:mml_admin/models/genre.dart';
import 'package:mml_admin/models/genre_bitrate.dart';
import 'package:mml_admin/models/id3_tag_filter.dart';
import 'package:mml_admin/models/language.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/record.dart';
import 'package:mml_admin/models/record_folder.dart';
import 'package:mml_admin/models/record_validation.dart';
import 'package:mml_admin/models/settings.dart';
import 'package:mml_admin/services/api.dart';

/// Service that handles the records data of the server.
class RecordService {
  /// Instance of the record service.
  static final RecordService _instance = RecordService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

  /// Private constructor of the service.
  RecordService._();

  /// Returns the singleton instance of the [RecordService].
  static RecordService getInstance() {
    return _instance;
  }

  /// Uploads a [file] with the given [fileName] and associated [groups] to the server.
  Future upload(File file, String fileName, List<String> groups) async {
    final lastModified = await file.lastModified();
    FormData formData = FormData.fromMap(
      {
        "file": MultipartFileExtended.fromFileSync(
          file.path,
          filename: fileName,
        )
      },
    );
    formData.fields.add(
      MapEntry(
        'LastModifiedDate',
        lastModified.toString(),
      ),
    );
    for (String group in groups) {
      formData.fields.add(
        MapEntry(
          'Groups',
          group,
        ),
      );
    }
    await _apiService.request(
      '/media/upload',
      data: formData,
      options: Options(method: 'POST'),
    );
  }

  /// Returns a list of records with the amount of [take] that match the given
  /// [filter] starting from the [offset].
  Future<ModelList> getRecords(
    String? filter,
    int? offset,
    int? take,
    ID3TagFilter? tagFilter,
  ) async {
    var params = <String, String?>{};

    if (filter != null) {
      params['filter'] = filter;
    }

    if (offset != null) {
      params['skip'] = offset.toString();
    }

    if (take != null) {
      params['take'] = take.toString();
    }

    var response = await _apiService.request(
      '/media/record/list',
      queryParameters: params,
      data: tagFilter != null ? tagFilter.toJson() : {},
      options: Options(
        method: 'POST',
      ),
    );

    return ModelList(
      List<Record>.from(
        response.data['items'].map((item) => Record.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Returns a list of artists with the amount of [take] starting from the [offset] and with the passed [filter],
  Future<ModelList> getArtists(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/media/record/artists',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
      options: Options(
        method: 'GET',
      ),
    );

    return ModelList(
      List<Artist>.from(
        response.data['items'].map((item) => Artist.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Returns a list of albums with the amount of [take] starting from the [offset] and with the passed [filter],
  Future<ModelList> getAlbums(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/media/record/albums',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
      options: Options(
        method: 'GET',
      ),
    );

    return ModelList(
      List<Album>.from(
        response.data['items'].map((item) => Album.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Returns a list of genres with the amount of [take] starting from the [offset] with the passed [filter],
  Future<ModelList> getGenres(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/media/record/genres',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
      options: Options(
        method: 'GET',
      ),
    );

    return ModelList(
      List<Genre>.from(
        response.data['items'].map((item) => Genre.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Returns a list of languages with the amount of [take] starting from the [offset] with the passed [filter],
  Future<ModelList> getLanguages(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/media/record/languages',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
      options: Options(
        method: 'GET',
      ),
    );

    return ModelList(
      List<Language>.from(
        response.data['items'].map((item) => Language.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Deletes the records with the given [recordIds] on the server.
  Future<void> delete<String>(List<String> recordIds) async {
    await _apiService.request(
      '/media/record/deleteList',
      data: recordIds,
      options: Options(
        method: 'POST',
        contentType: Headers.jsonContentType,
      ),
    );
  }

  /// Loads the record with the given [id] from the server.
  ///
  /// Returns the [Record] instance or null if the record was not found.
  Future<Record> getRecord(String id) async {
    var response = await _apiService.request(
      '/media/record/$id',
      options: Options(
        method: 'GET',
      ),
    );

    return Record.fromJson(response.data);
  }

  /// Updates the given [Record] on the server.
  updateRecord(Record record) async {
    await _apiService.request(
      '/media/record',
      data: record.toJson(),
      options: Options(
        method: 'POST',
      ),
    );
  }

  /// Loads the settings for records
  Future<Settings> getSettings() async {
    var response = await _apiService.request(
      '/media/settings',
      options: Options(
        method: 'GET',
      ),
    );

    return Settings.fromJson(response.data);
  }

  /// Saves the record settings
  saveSettings(Settings settings) async {
    await _apiService.request(
      '/media/settings',
      data: settings.toJson(),
      options: Options(
        method: 'POST',
        contentType: Headers.jsonContentType,
      ),
    );
  }

  /// Loads the validation settings for records.
  Future<RecordValidation> getValidationSettings() async {
    var response = await _apiService.request(
      '/media/settings/UploadValidation',
      options: Options(
        method: 'GET',
      ),
    );

    if (response.data == null || response.data.isEmpty) {
      return RecordValidation();
    }

    return RecordValidation.fromJson(json.decode(response.data));
  }

  /// Saves the record validation settings.
  saveValidationSettings(RecordValidation settings) async {
    await _apiService.request(
      '/media/settings/UploadValidation',
      data: Map<String, String>.from(<String, String>{
        "value": json.encode(
          settings.toJson(),
        ),
      }),
      options: Options(
        method: 'POST',
        contentType: Headers.jsonContentType,
      ),
    );
  }

  /// Returns a list of record folder group with the amount of [take] that match the given
  /// [filter] starting from the [offset].
  Future<ModelList> getRecordsFolder(
    String? filter,
    int? offset,
    int? take,
    ID3TagFilter subfilter,
  ) async {
    var params = <String, String?>{};

    if (filter != null) {
      params['filter'] = filter;
    }

    if (offset != null) {
      params['skip'] = offset.toString();
    }

    if (take != null) {
      params['take'] = take.toString();
    }

    var response = await _apiService.request(
      '/media/record/listFolder',
      queryParameters: params,
      data: subfilter.toJson(),
      options: Options(
        method: 'POST',
      ),
    );

    return ModelList(
      List<RecordFolder>.from(
        response.data['items'].map(
          (item) => RecordFolder.fromJson(item),
        ),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Deletes all records within the given folders in [list].
  Future<void> deleteFolder(List<RecordFolder> list) async {
    await _apiService.request(
      '/media/record/deleteFolders',
      data: list,
      options: Options(
        method: 'POST',
        contentType: Headers.jsonContentType,
      ),
    );
  }

  /// Load all existing [GenreBitrate].
  Future<List<GenreBitrate>> loadBitrates() async {
    var response = await _apiService.request(
      '/media/record/bitrates',
      options: Options(
        method: 'GET',
      ),
    );

    return List<GenreBitrate>.from(
      response.data['items'].map((item) => GenreBitrate.fromJson(item)),
    );
  }

  /// Load all existing [GenreBitrate].
  Future<void> updateBitrates(List<GenreBitrate> bitrates) async {
    await _apiService.request(
      '/media/record/bitrates',
      data: bitrates,
      options: Options(
        method: 'POST',
        contentType: Headers.jsonContentType,
      ),
    );
  }

  /// Deletes one [GenreBitrate].
  Future<void> deleteBitrate(GenreBitrate bitrate) async {
    if (bitrate.genreId == null || bitrate.genreId!.isEmpty) {
      return;
    }
    await _apiService.request(
      '/media/record/bitrate/${bitrate.genreId}',
      options: Options(
        method: 'DELETE',
        contentType: Headers.jsonContentType,
      ),
    );
  }

  /// Assigns items to groups.
  Future assign(List<String> items, List<String> groups) async {
    await _apiService.request(
      '/media/record/assign',
      data: {
        "items": items,
        "groups": groups,
      },
      options: Options(
        method: 'POST',
        contentType: Headers.jsonContentType,
      ),
    );
  }

  /// Assigns folders to selectedGroups.
  Future assignFolders(
    List<RecordFolder> list,
    List<String> selectedGroups,
  ) async {
    await _apiService.request(
      '/media/record/assignFolder',
      data: {
        "items": list,
        "groups": selectedGroups,
      },
      options: Options(
        method: 'POST',
        contentType: Headers.jsonContentType,
      ),
    );
  }
}
