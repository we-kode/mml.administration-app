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

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
  'isDeletable': instance.isDeletable,
  'artistId': ?instance.artistId,
  'name': ?instance.name,
};
