// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordFolder _$RecordFolderFromJson(Map<String, dynamic> json) => RecordFolder(
      year: json['year'] as int,
      month: json['month'] as int?,
      day: json['day'] as int?,
      isDeletable: json['isDeletable'] as bool? ?? true,
    );

Map<String, dynamic> _$RecordFolderToJson(RecordFolder instance) {
  final val = <String, dynamic>{
    'isDeletable': instance.isDeletable,
    'year': instance.year,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('month', instance.month);
  writeNotNull('day', instance.day);
  return val;
}
