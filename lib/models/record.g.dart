// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) => Record(
  recordId: json['recordId'] as String?,
  title: json['title'] as String?,
  trackNumber: (json['trackNumber'] as num?)?.toInt(),
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  duration: (json['duration'] as num?)?.toDouble() ?? 0,
  album: json['album'] as String?,
  artist: json['artist'] as String?,
  genre: json['genre'] as String?,
  language: json['language'] as String?,
  bitrate: (json['bitrate'] as num?)?.toInt(),
  cover: json['cover'] as String?,
  locked: json['locked'] as bool?,
  isDeletable: json['isDeletable'] as bool? ?? true,
  groups: (json['groups'] as List<dynamic>?)
      ?.map((e) => Group.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
  'isDeletable': instance.isDeletable,
  'recordId': ?instance.recordId,
  'title': ?instance.title,
  'trackNumber': ?instance.trackNumber,
  'date': ?instance.date?.toIso8601String(),
  'duration': instance.duration,
  'artist': ?instance.artist,
  'genre': ?instance.genre,
  'album': ?instance.album,
  'language': ?instance.language,
  'bitrate': ?instance.bitrate,
  'cover': ?instance.cover,
  'locked': ?instance.locked,
  'groups': instance.groups.map((e) => e.toJson()).toList(),
};
