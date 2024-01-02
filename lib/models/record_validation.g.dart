// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_validation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordValidation _$RecordValidationFromJson(Map<String, dynamic> json) =>
    RecordValidation(
      isRequiredLanguage: json['isRequiredLanguage'] as bool?,
      isRequiredTitle: json['isRequiredTitle'] as bool?,
      isRequiredTrackNumber: json['isRequiredTrackNumber'] as bool?,
      isRequiredArtist: json['isRequiredArtist'] as bool?,
      isRequiredCover: json['isRequiredCover'] as bool?,
      isRequiredAlbum: json['isRequiredAlbum'] as bool?,
      albums: json['albums'] as String?,
      isRequiredGenre: json['isRequiredGenre'] as bool?,
      genres: json['genres'] as String?,
      fileNameTemplate: json['fileNameTemplate'] as String?,
    );

Map<String, dynamic> _$RecordValidationToJson(RecordValidation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('isRequiredLanguage', instance.isRequiredLanguage);
  writeNotNull('isRequiredTitle', instance.isRequiredTitle);
  writeNotNull('isRequiredArtist', instance.isRequiredArtist);
  writeNotNull('isRequiredTrackNumber', instance.isRequiredTrackNumber);
  writeNotNull('isRequiredCover', instance.isRequiredCover);
  writeNotNull('isRequiredAlbum', instance.isRequiredAlbum);
  writeNotNull('albums', instance.albums);
  writeNotNull('isRequiredGenre', instance.isRequiredGenre);
  writeNotNull('genres', instance.genres);
  writeNotNull('fileNameTemplate', instance.fileNameTemplate);
  return val;
}
