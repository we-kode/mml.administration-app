// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_validation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordValidation _$RecordValidationFromJson(Map<String, dynamic> json) =>
    RecordValidation(
      validateLanguage: $enumDecodeNullable(
          _$RecordValidationStateEnumMap, json['validateLanguage']),
      validateTitle: $enumDecodeNullable(
          _$RecordValidationStateEnumMap, json['validateTitle']),
      validateTrackNumber: $enumDecodeNullable(
          _$RecordValidationStateEnumMap, json['validateTrackNumber']),
      validateArtist: $enumDecodeNullable(
          _$RecordValidationStateEnumMap, json['validateArtist']),
      validateCover: $enumDecodeNullable(
          _$RecordValidationStateEnumMap, json['validateCover']),
      validateAlbum: $enumDecodeNullable(
          _$RecordValidationStateEnumMap, json['validateAlbum']),
      albums: json['albums'] as String?,
      validateGenre: $enumDecodeNullable(
          _$RecordValidationStateEnumMap, json['validateGenre']),
      genres: json['genres'] as String?,
      fileNameTemplate: json['fileNameTemplate'] as String?,
    )..validationErrors = (json['validationErrors'] as List<dynamic>)
        .map((e) => e as String)
        .toList();

Map<String, dynamic> _$RecordValidationToJson(RecordValidation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('validateLanguage',
      _$RecordValidationStateEnumMap[instance.validateLanguage]);
  writeNotNull(
      'validateTitle', _$RecordValidationStateEnumMap[instance.validateTitle]);
  writeNotNull('validateArtist',
      _$RecordValidationStateEnumMap[instance.validateArtist]);
  writeNotNull('validateTrackNumber',
      _$RecordValidationStateEnumMap[instance.validateTrackNumber]);
  writeNotNull(
      'validateCover', _$RecordValidationStateEnumMap[instance.validateCover]);
  writeNotNull(
      'validateAlbum', _$RecordValidationStateEnumMap[instance.validateAlbum]);
  writeNotNull('albums', instance.albums);
  writeNotNull(
      'validateGenre', _$RecordValidationStateEnumMap[instance.validateGenre]);
  writeNotNull('genres', instance.genres);
  writeNotNull('fileNameTemplate', instance.fileNameTemplate);
  val['validationErrors'] = instance.validationErrors;
  return val;
}

const _$RecordValidationStateEnumMap = {
  RecordValidationState.dontvalidate: 'dontvalidate',
  RecordValidationState.validate: 'validate',
  RecordValidationState.required: 'required',
};
