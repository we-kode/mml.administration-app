// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id3_tag_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ID3TagFilter _$ID3TagFilterFromJson(Map<String, dynamic> json) => ID3TagFilter(
  artists: (json['artists'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
  albums: (json['albums'] as List<dynamic>?)?.map((e) => e as String).toList(),
  languages: (json['languages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  groups: (json['groups'] as List<dynamic>?)?.map((e) => e as String).toList(),
  instances: (json['instances'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  syncStates: (json['syncStates'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  unassigned: json['unassigned'] as bool? ?? false,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
)..isGrouped = json['isGrouped'] as bool;

Map<String, dynamic> _$ID3TagFilterToJson(ID3TagFilter instance) =>
    <String, dynamic>{
      'isGrouped': instance.isGrouped,
      'artists': instance.artists,
      'genres': instance.genres,
      'albums': instance.albums,
      'languages': instance.languages,
      'groups': instance.groups,
      'unassigned': instance.unassigned,
      'instances': instance.instances,
      'syncStates': instance.syncStates,
      'startDate': ?instance.startDate?.toIso8601String(),
      'endDate': ?instance.endDate?.toIso8601String(),
    };
