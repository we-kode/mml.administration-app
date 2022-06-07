// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clientRegistration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientRegistration _$ClientRegistrationFromJson(Map<String, dynamic> json) =>
    ClientRegistration(
      token: json['token'] as String,
      url: json['url'] as String,
      appKey: json['appKey'] as String,
    );

Map<String, dynamic> _$ClientRegistrationToJson(ClientRegistration instance) =>
    <String, dynamic>{
      'token': instance.token,
      'url': instance.url,
      'appKey': instance.appKey,
    };
