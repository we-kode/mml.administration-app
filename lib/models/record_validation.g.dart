// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_validation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordValidation _$RecordValidationFromJson(Map<String, dynamic> json) =>
    RecordValidation(
        validateLanguage: $enumDecodeNullable(
          _$RecordValidationStateEnumMap,
          json['validateLanguage'],
        ),
        validateTitle: $enumDecodeNullable(
          _$RecordValidationStateEnumMap,
          json['validateTitle'],
        ),
        validateTrackNumber: $enumDecodeNullable(
          _$RecordValidationStateEnumMap,
          json['validateTrackNumber'],
        ),
        validateArtist: $enumDecodeNullable(
          _$RecordValidationStateEnumMap,
          json['validateArtist'],
        ),
        validateCover: $enumDecodeNullable(
          _$RecordValidationStateEnumMap,
          json['validateCover'],
        ),
        validateAlbum: $enumDecodeNullable(
          _$RecordValidationStateEnumMap,
          json['validateAlbum'],
        ),
        albums: json['albums'] as String?,
        validateGenre: $enumDecodeNullable(
          _$RecordValidationStateEnumMap,
          json['validateGenre'],
        ),
        genres: json['genres'] as String?,
        fileNameTemplate: json['fileNameTemplate'] as String?,
      )
      ..validationErrors = (json['validationErrors'] as List<dynamic>)
          .map((e) => e as String)
          .toList();

Map<String, dynamic> _$RecordValidationToJson(
  RecordValidation instance,
) => <String, dynamic>{
  'validateLanguage':
      ?_$RecordValidationStateEnumMap[instance.validateLanguage],
  'validateTitle': ?_$RecordValidationStateEnumMap[instance.validateTitle],
  'validateArtist': ?_$RecordValidationStateEnumMap[instance.validateArtist],
  'validateTrackNumber':
      ?_$RecordValidationStateEnumMap[instance.validateTrackNumber],
  'validateCover': ?_$RecordValidationStateEnumMap[instance.validateCover],
  'validateAlbum': ?_$RecordValidationStateEnumMap[instance.validateAlbum],
  'albums': ?instance.albums,
  'validateGenre': ?_$RecordValidationStateEnumMap[instance.validateGenre],
  'genres': ?instance.genres,
  'fileNameTemplate': ?instance.fileNameTemplate,
  'validationErrors': instance.validationErrors,
};

const _$RecordValidationStateEnumMap = {
  RecordValidationState.doNotValidate: 'doNotValidate',
  RecordValidationState.validate: 'validate',
  RecordValidationState.required: 'required',
};
