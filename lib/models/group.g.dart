// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      id: json['id'] as String?,
      name: json['name'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isDeletable: json['isDeletable'] as bool? ?? true,
    );

Map<String, dynamic> _$GroupToJson(Group instance) {
  final val = <String, dynamic>{
    'isDeletable': instance.isDeletable,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  val['isDefault'] = instance.isDefault;
  return val;
}
