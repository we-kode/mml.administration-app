import 'dart:io';

import 'package:id3tag/id3tag.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/extensions/flag.dart';

part 'record_validation.g.dart';

/// Record validation model that holds all information of a record validation setting.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RecordValidation {
  /// Is language tag required to be set?.
  RecordValidationState? validateLanguage;

  /// Is title tag required to be set?.
  RecordValidationState? validateTitle;

  /// Is artist tag required to be set?.
  RecordValidationState? validateArtist;

  /// Is track number tag required to be set?.
  RecordValidationState? validateTrackNumber;

  /// Is at least one cover required to be set?.
  RecordValidationState? validateCover;

  /// Is album tag required to be set?.
  RecordValidationState? validateAlbum;

  /// List of acceptable albums.
  String? albums;

  /// Is genre tag required to be set?.
  RecordValidationState? validateGenre;

  /// List of acceptable genres.
  String? genres;

  /// Template Regex of file name. Deafult is everything accepted.
  String? fileNameTemplate;

  List<String> validationErrors = List.empty(growable: true);

  /// Creates a new record validation instance with the given values.
  RecordValidation({
    this.validateLanguage,
    this.validateTitle,
    this.validateTrackNumber,
    this.validateArtist,
    this.validateCover,
    this.validateAlbum,
    this.albums,
    this.validateGenre,
    this.genres,
    this.fileNameTemplate,
  });

  /// Converts a json object/map to the record validation model.
  factory RecordValidation.fromJson(Map<String, dynamic> json) =>
      _$RecordValidationFromJson(json);

  /// Converts the current record validation model to a json object/map.
  Map<String, dynamic> toJson() => _$RecordValidationToJson(this);

  /// Assigns the new filter [value] to the [ID3TagFilters] identifier.
  void operator []=(String identifier, RecordValidationState value) {
    switch (identifier) {
      case RecordValidationKeys.artist:
        validateArtist = value;
        break;
      case RecordValidationKeys.genre:
        validateGenre = value;
        break;
      case RecordValidationKeys.album:
        validateAlbum = value;
        break;
      case RecordValidationKeys.language:
        validateLanguage = value;
        break;
      case RecordValidationKeys.title:
        validateTitle = value;
        break;
      case RecordValidationKeys.number:
        validateTrackNumber = value;
        break;
      case RecordValidationKeys.cover:
        validateCover = value;
        break;
    }
  }

  /// Returns the saved values of the [ID3TagFilters] identifier.
  RecordValidationState operator [](String identifier) {
    switch (identifier) {
      case RecordValidationKeys.artist:
        return validateArtist ?? RecordValidationState.dontvalidate;
      case RecordValidationKeys.genre:
        return validateGenre ?? RecordValidationState.dontvalidate;
      case RecordValidationKeys.album:
        return validateAlbum ?? RecordValidationState.dontvalidate;
      case RecordValidationKeys.language:
        return validateLanguage ?? RecordValidationState.dontvalidate;
      case RecordValidationKeys.title:
        return validateTitle ?? RecordValidationState.dontvalidate;
      case RecordValidationKeys.number:
        return validateTrackNumber ?? RecordValidationState.dontvalidate;
      case RecordValidationKeys.cover:
        return validateCover ?? RecordValidationState.dontvalidate;
      default:
        return RecordValidationState.dontvalidate;
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
    if (validateLanguage != null &&
        validateLanguage != RecordValidationState.dontvalidate) {
      final isAnyLanguage =
          metadata.frames.any((element) => element.frameName == "TLAN");
      var isValidLanguage = validateLanguage == RecordValidationState.required
          ? isAnyLanguage
          : true;

      if (isAnyLanguage) {
        final language =
            metadata.frames.firstWhere((element) => element.frameName == "TLAN")
                as TextInformation;
        final languages = language.value.asFlag();
        isValidLanguage &=
            (validateLanguage == RecordValidationState.required &&
                    language.value.isNotEmpty) ||
                languages.isNotEmpty && !languages.contains('🏁');
      }

      isValid &= isValidLanguage;

      if (!isValidLanguage) {
        validationErrors.add(RecordValidationErrors.language);
      }
    }

    // Check if title is required and set.
    if (validateTitle != null &&
        validateTitle == RecordValidationState.required) {
      final isValidTitle = metadata.title?.isNotEmpty ?? false;
      isValid &= isValidTitle;
      if (!isValidTitle) {
        validationErrors.add(RecordValidationErrors.title);
      }
    }

    // Check if number is required and set.
    if (validateTrackNumber != null &&
        validateTrackNumber == RecordValidationState.required) {
      final isValidTrackNumber = metadata.track?.isNotEmpty ?? false;
      isValid &= isValidTrackNumber;
      if (!isValidTrackNumber) {
        validationErrors.add(RecordValidationErrors.number);
      }
    }

    // Check if cover is required and at least one is set.
    if (validateCover != null &&
        validateCover == RecordValidationState.required) {
      final isValidPictures = metadata.pictures.isNotEmpty;
      isValid &= isValidPictures;
      if (!isValidPictures) {
        validationErrors.add(RecordValidationErrors.cover);
      }
    }

    // Check if artist is required and set.
    if (validateArtist != null &&
        validateArtist == RecordValidationState.required) {
      final isValidArtist = metadata.artist?.isNotEmpty ?? false;
      isValid &= isValidArtist;
      if (!isValidArtist) {
        validationErrors.add(RecordValidationErrors.artist);
      }
    }

    // Check if album is required and one is set. If albums string is not empty check if is part of accepted albums.
    if (validateAlbum != null &&
        validateAlbum != RecordValidationState.dontvalidate) {
      var isAnyAlbum = metadata.album?.isNotEmpty ?? false;
      isValid &=
          validateAlbum == RecordValidationState.required ? isAnyAlbum : true;
      if (validateAlbum == RecordValidationState.required && !isAnyAlbum) {
        validationErrors.add(RecordValidationErrors.album);
      }

      if (albums != null) {
        final albumsList = albums!.split(',');
        final isValidAlbums = albumsList.isEmpty ||
            albumsList.contains(metadata.album) ||
            validateAlbum == RecordValidationState.validate &&
                (metadata.album == null || metadata.album!.isEmpty);
        isValid &= isValidAlbums;
        if (!isValidAlbums) {
          validationErrors.add(RecordValidationErrors.albums);
        }
      }
    }

    // Check if genre is required and one is set. If genres string is not empty check if is part of accepted genres.
    if (validateGenre != null &&
        validateGenre != RecordValidationState.dontvalidate) {
      final isAnyGenre = metadata.frames.any(
        (element) => element.frameName == "TCON",
      );
      var isValidGenre =
          validateGenre == RecordValidationState.required ? isAnyGenre : true;
      TextInformation? genre;
      if (isAnyGenre) {
        genre = metadata.frames.firstWhere(
          (element) => element.frameName == "TCON",
        ) as TextInformation;
        isValidGenre &= validateGenre == RecordValidationState.required
            ? genre.value.isNotEmpty
            : true;
      }

      isValid &= isValidGenre;
      if (!isValidGenre) {
        validationErrors.add(RecordValidationErrors.genre);
      }

      if (genres != null) {
        final genreList = genres!.split(',');
        final isValidGenres = genreList.isEmpty ||
            genreList.contains(genre?.value) ||
            validateGenre == RecordValidationState.validate && genre == null;
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

/// States of validation.
enum RecordValidationState { dontvalidate, validate, required }

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
