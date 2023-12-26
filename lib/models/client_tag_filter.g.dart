// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_tag_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientTagFilter _$ClientTagFilterFromJson(Map<String, dynamic> json) =>
    ClientTagFilter(
      groups:
          (json['groups'] as List<dynamic>?)?.map((e) => e as String).toList(),
      onlyNew: json['onlyNew'] as bool? ?? false,
    )..isGrouped = json['isGrouped'] as bool;

Map<String, dynamic> _$ClientTagFilterToJson(ClientTagFilter instance) =>
    <String, dynamic>{
      'isGrouped': instance.isGrouped,
      'groups': instance.groups,
      'onlyNew': instance.onlyNew,
    };
