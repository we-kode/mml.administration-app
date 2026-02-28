// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
  albumId: json['albumId'] as String?,
  albumName: json['albumName'] as String?,
  isDeletable: json['isDeletable'] as bool? ?? false,
);

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
  'isDeletable': instance.isDeletable,
  'albumId': ?instance.albumId,
  'albumName': ?instance.albumName,
};
