// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      artistId: json['artistId'] as String?,
      name: json['name'] as String?,
      isDeletable: json['isDeletable'] as bool? ?? false,
    );

Map<String, dynamic> _$ArtistToJson(Artist instance) {
  final val = <String, dynamic>{
    'isDeletable': instance.isDeletable,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('artistId', instance.artistId);
  writeNotNull('name', instance.name);
  return val;
}
