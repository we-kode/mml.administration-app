// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Peer _$PeerFromJson(Map<String, dynamic> json) => Peer(
  peerId: json['peerId'] as String,
  instance: json['instance'] as String,
  baseUrl: json['baseUrl'] as String,
  state: (json['state'] as num).toInt(),
  jwksUpdatedAt: json['jwksUpdatedAt'] == null
      ? null
      : DateTime.parse(json['jwksUpdatedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  isDeletable: json['isDeletable'] as bool? ?? true,
);

Map<String, dynamic> _$PeerToJson(Peer instance) => <String, dynamic>{
  'isDeletable': instance.isDeletable,
  'peerId': instance.peerId,
  'instance': instance.instance,
  'baseUrl': instance.baseUrl,
  'state': instance.state,
  'jwksUpdatedAt': ?instance.jwksUpdatedAt?.toIso8601String(),
  'createdAt': ?instance.createdAt?.toIso8601String(),
};
