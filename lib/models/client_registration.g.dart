// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientRegistration _$ClientRegistrationFromJson(Map<String, dynamic> json) =>
    ClientRegistration(
      token: json['token'] as String,
      appKey: json['appKey'] as String,
      endpoint: json['endpoint'] as String?,
    );

Map<String, dynamic> _$ClientRegistrationToJson(ClientRegistration instance) {
  final val = <String, dynamic>{
    'token': instance.token,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('endpoint', instance.endpoint);
  val['appKey'] = instance.appKey;
  return val;
}
