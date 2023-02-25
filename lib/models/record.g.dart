// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) => Record(
      recordId: json['recordId'] as String?,
      title: json['title'] as String?,
      trackNumber: json['trackNumber'] as int?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      duration: (json['duration'] as num?)?.toDouble() ?? 0,
      album: json['album'] as String?,
      artist: json['artist'] as String?,
      genre: json['genre'] as String?,
      language: json['language'] as String?,
      isDeletable: json['isDeletable'] as bool? ?? true,
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecordToJson(Record instance) {
  final val = <String, dynamic>{
    'isDeletable': instance.isDeletable,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('recordId', instance.recordId);
  writeNotNull('title', instance.title);
  writeNotNull('trackNumber', instance.trackNumber);
  writeNotNull('date', instance.date?.toIso8601String());
  val['duration'] = instance.duration;
  writeNotNull('artist', instance.artist);
  writeNotNull('genre', instance.genre);
  writeNotNull('album', instance.album);
  writeNotNull('language', instance.language);
  val['groups'] = instance.groups.map((e) => e.toJson()).toList();
  return val;
}
