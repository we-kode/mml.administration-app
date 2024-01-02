import 'dart:io';

import 'package:id3tag/id3tag.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/extensions/flag.dart';

part 'record_validation.g.dart';

/// Record validation model that holds all information of a record validation setting.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RecordValidation {
  /// Is language tag required to be set?.
  bool? isRequiredLanguage;

  /// Is title tag required to be set?.
  bool? isRequiredTitle;

  /// Is artist tag required to be set?.
  bool? isRequiredArtist;

  /// Is track number tag required to be set?.
  bool? isRequiredTrackNumber;

  /// Is at least one cover required to be set?.
  bool? isRequiredCover;

  /// Is album tag required to be set?.
  bool? isRequiredAlbum;

  /// List of acceptable albums.
  String? albums;

  /// Is genre tag required to be set?.
  bool? isRequiredGenre;

  /// List of acceptable genres.
  String? genres;

  /// Template Regex of file name. Deafult is everything accepted.
  String? fileNameTemplate;

  List<String> validationErrors = List.empty(growable: true);

  /// Creates a new record validation instance with the given values.
  RecordValidation({
    this.isRequiredLanguage,
    this.isRequiredTitle,
    this.isRequiredTrackNumber,
    this.isRequiredArtist,
    this.isRequiredCover,
    this.isRequiredAlbum,
    this.albums,
    this.isRequiredGenre,
    this.genres,
    this.fileNameTemplate,
  });

  /// Converts a json object/map to the record validation model.
  factory RecordValidation.fromJson(Map<String, dynamic> json) =>
      _$RecordValidationFromJson(json);

  /// Converts the current record validation model to a json object/map.
  Map<String, dynamic> toJson() => _$RecordValidationToJson(this);

  /// Assigns the new filter [value] to the [ID3TagFilters] identifier.
  void operator []=(String identifier, bool value) {
    switch (identifier) {
      case RecordValidationKeys.artist:
        isRequiredArtist = value;
        break;
      case RecordValidationKeys.genre:
        isRequiredGenre = value;
        break;
      case RecordValidationKeys.album:
        isRequiredAlbum = value;
        break;
      case RecordValidationKeys.language:
        isRequiredLanguage = value;
        break;
      case RecordValidationKeys.title:
        isRequiredTitle = value;
        break;
      case RecordValidationKeys.number:
        isRequiredTrackNumber = value;
        break;
      case RecordValidationKeys.cover:
        isRequiredCover = value;
        break;
    }
  }

  /// Returns the saved values of the [ID3TagFilters] identifier.
  bool operator [](String identifier) {
    switch (identifier) {
      case RecordValidationKeys.artist:
        return isRequiredArtist ?? false;
      case RecordValidationKeys.genre:
        return isRequiredGenre ?? false;
      case RecordValidationKeys.album:
        return isRequiredAlbum ?? false;
      case RecordValidationKeys.language:
        return isRequiredLanguage ?? false;
      case RecordValidationKeys.title:
        return isRequiredTitle ?? false;
      case RecordValidationKeys.number:
        return isRequiredTrackNumber ?? false;
      case RecordValidationKeys.cover:
        return isRequiredCover ?? false;
      default:
        return false;
    }
  }

  /// Validates file by set required propertioes.
  ///
  /// Returns true, if all required properties matches.
  Future<bool> isValid(String fileName, File file) async {
    final parser = ID3TagReader(file);
    final metadata = parser.readTagSync();
    bool isValid = true;
    validationErrors.clear();

    // Check if language is required and language is part of known languages.
    if (isRequiredLanguage ?? false) {
      final isAnyLanguage =
          metadata.frames.any((element) => element.frameName == "TLAN");
      var isValidLanguage = isAnyLanguage;
      if (isAnyLanguage) {
        final language =
            metadata.frames.firstWhere((element) => element.frameName == "TLAN")
                as TextInformation;
        final languages = language.value.asFlag();
        isValidLanguage &= language.value.isNotEmpty &&
            languages.isNotEmpty &&
            !languages.contains('🏁');
      }

      isValid &= isValidLanguage;

      if (!isValidLanguage) {
        validationErrors.add(RecordValidationErrors.language);
      }
    }

    // Check if title is required and set.
    if (isRequiredTitle ?? false) {
      final isValidTitle = metadata.title?.isNotEmpty ?? false;
      isValid &= isValidTitle;
      if (!isValidTitle) {
        validationErrors.add(RecordValidationErrors.title);
      }
    }

    // Check if number is required and set.
    if (isRequiredTrackNumber ?? false) {
      final isValidTrackNumber = metadata.track?.isNotEmpty ?? false;
      isValid &= isValidTrackNumber;
      if (!isValidTrackNumber) {
        validationErrors.add(RecordValidationErrors.number);
      }
    }

    // Check if cover is required and at least one is set.
    if (isRequiredCover ?? false) {
      final isValidPictures = metadata.pictures.isNotEmpty;
      isValid &= isValidPictures;
      if (!isValidPictures) {
        validationErrors.add(RecordValidationErrors.cover);
      }
    }

    // Check if artist is required and set.
    if (isRequiredArtist ?? false) {
      final isValidArtist = metadata.artist?.isNotEmpty ?? false;
      isValid &= isValidArtist;
      if (!isValidArtist) {
        validationErrors.add(RecordValidationErrors.artist);
      }
    }

    // Check if album is required and one is set. If albums string is not empty check if is part of accepted albums.
    if (isRequiredAlbum ?? false) {
      var isAnyAlbum = metadata.album?.isNotEmpty ?? false;
      isValid &= isAnyAlbum;
      if (!isAnyAlbum) {
        validationErrors.add(RecordValidationErrors.album);
      }

      if (albums != null) {
        final albumsList = albums!.split(',');
        final isValidAlbums =
            albumsList.isEmpty || albumsList.contains(metadata.album);
        isValid &= isValidAlbums;
        if (!isValidAlbums) {
          validationErrors.add(RecordValidationErrors.albums);
        }
      }
    }

    // Check if genre is required and one is set. If genres string is not empty check if is part of accepted genres.
    if (isRequiredGenre ?? false) {
      final isAnyGenre = metadata.frames.any(
        (element) => element.frameName == "TCON",
      );
      var isValidGenre = isAnyGenre;
      TextInformation? genre;
      if (isAnyGenre) {
        genre = metadata.frames.firstWhere(
          (element) => element.frameName == "TCON",
        ) as TextInformation;
        isValidGenre &= genre.value.isNotEmpty;
      }

      isValid &= isValidGenre;
      if (!isValidGenre) {
        validationErrors.add(RecordValidationErrors.genre);
      }

      if (genres != null) {
        final genreList = genres!.split(',');
        final isValidGenres =
            genreList.isEmpty || genreList.contains(genre?.value);
        isValid &= isValidGenres;
        if (!isValidGenres) {
          validationErrors.add(RecordValidationErrors.genres);
        }
      }
    }

    // Check if file name matches accepted file name template.
    final fileNameCheck = RegExp(fileNameTemplate ?? '.*');
    final isValidFileName = fileNameCheck.hasMatch(fileName);
    isValid &= isValidFileName;
    if (!isValidFileName) {
      validationErrors.add(RecordValidationErrors.filename);
    }
    return isValid;
  }
}

/// Holds the identifiers on which records can be validated.
abstract class RecordValidationKeys {
  /// Artists tag identifier.
  static const String language = "language";

  /// Albums tag identifier.
  static const String album = "album";

  /// Genres tag identifier.
  static const String genre = "genre";

  /// Artist tag identifier.
  static const String artist = "artist";

  /// Title tag identifier.
  static const String title = "title";

  /// Number tag identifier.
  static const String number = "number";

  /// Cover tag identifier.
  static const String cover = "cover";
}

/// Holds the identifiers of Erros, whic can accure on validation.
abstract class RecordValidationErrors {
  /// Langae tag identifier.
  static const String language = "uploadInvalidLanguage";

  /// Albums tag identifier.
  static const String album = "uploadInvalidAlbum";
  static const String albums = "uploadInvalidAlbums";

  /// Genres tag identifier.
  static const String genre = "uploadInvalidGenre";
  static const String genres = "uploadInvalidGenres";

  /// Artist tag identifier.
  static const String artist = "uploadInvalidArtist";

  /// Title tag identifier.
  static const String title = "uploadInvalidTitle";

  /// Number tag identifier.
  static const String number = "uploadInvalidNumber";

  /// Cover tag identifier.
  static const String cover = "uploadInvalidCover";

  /// Filename tag identifier
  static const String filename = "uploadInvalidFilenameFormat";
}
