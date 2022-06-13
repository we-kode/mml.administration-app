import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'client_registration.g.dart';

/// Client model that holds all information to register a client.
@JsonSerializable(includeIfNull: false)
class ClientRegistration {
  /// The registration token.
  final String token;

  /// Endpoint of the api for the client.
  String? endpoint;

  /// The app key, the client needs to authentiacate for api calls.
  final String appKey;

  /// Creates a new [ClientRegistration] with the given values.
  ClientRegistration(
      {required this.token, required this.appKey, this.endpoint});

  /// Converts a json object/map to the model.
  factory ClientRegistration.fromJson(Map<String, dynamic> json) =>
      _$ClientRegistrationFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$ClientRegistrationToJson(this);

  @override
  String toString() => base64Encode(utf8.encode(jsonEncode(toJson())));
}
