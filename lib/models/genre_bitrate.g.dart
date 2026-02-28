// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_bitrate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreBitrate _$GenreBitrateFromJson(Map<String, dynamic> json) => GenreBitrate(
  genreId: json['genreId'] as String?,
  name: json['name'] as String?,
  bitrate: (json['bitrate'] as num?)?.toInt(),
  isDeletable: json['isDeletable'] as bool? ?? true,
);

Map<String, dynamic> _$GenreBitrateToJson(GenreBitrate instance) =>
    <String, dynamic>{
      'isDeletable': instance.isDeletable,
      'genreId': ?instance.genreId,
      'name': ?instance.name,
      'bitrate': ?instance.bitrate,
    };
