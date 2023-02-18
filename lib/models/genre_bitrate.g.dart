// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_bitrate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreBitrate _$GenreBitrateFromJson(Map<String, dynamic> json) => GenreBitrate(
      genreId: json['genreId'] as String?,
      name: json['name'] as String?,
      bitrate: json['bitrate'] as int?,
      isDeletable: json['isDeletable'] as bool? ?? true,
    );

Map<String, dynamic> _$GenreBitrateToJson(GenreBitrate instance) {
  final val = <String, dynamic>{
    'isDeletable': instance.isDeletable,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('genreId', instance.genreId);
  writeNotNull('name', instance.name);
  writeNotNull('bitrate', instance.bitrate);
  return val;
}
