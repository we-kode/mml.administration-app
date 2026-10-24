// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rule _$RuleFromJson(Map<String, dynamic> json) => Rule(
  ruleId: json['ruleId'] as String?,
  direction: (json['direction'] as num).toInt(),
  peers: (json['peers'] as List<dynamic>?)
      ?.map((e) => Peer.fromJson(e as Map<String, dynamic>))
      .toList(),
  artists: (json['artists'] as List<dynamic>?)
      ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
      .toList(),
  albums: (json['albums'] as List<dynamic>?)
      ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
      .toList(),
  genres: (json['genres'] as List<dynamic>?)
      ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
      .toList(),
  groups: (json['groups'] as List<dynamic>?)
      ?.map((e) => Group.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RuleToJson(Rule instance) => <String, dynamic>{
  'ruleId': ?instance.ruleId,
  'direction': instance.direction,
  'peers': instance.peers.map((e) => e.toJson()).toList(),
  'artists': instance.artists.map((e) => e.toJson()).toList(),
  'albums': instance.albums.map((e) => e.toJson()).toList(),
  'genres': instance.genres.map((e) => e.toJson()).toList(),
  'groups': instance.groups.map((e) => e.toJson()).toList(),
};
