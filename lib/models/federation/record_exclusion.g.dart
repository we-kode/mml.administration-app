// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_exclusion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordExclusion _$RecordExclusionFromJson(Map<String, dynamic> json) =>
    RecordExclusion(
      peerId: json['peerId'] as String,
      instance: json['instance'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RecordExclusionToJson(RecordExclusion instance) =>
    <String, dynamic>{
      'peerId': instance.peerId,
      'instance': instance.instance,
      'createdAt': instance.createdAt.toIso8601String(),
    };
