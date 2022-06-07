import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'clientRegistration.g.dart';

/// Client model that holds all information of a client.
@JsonSerializable(includeIfNull: false)
class ClientRegistration {
  /// Id of the client.
  final String token;
  final String url;
  final String appKey;

  /// Creates a new client instance with the given values.
  ClientRegistration(
      {required this.token, required this.url, required this.appKey});

  /// Converts a json object/map to the client model.
  factory ClientRegistration.fromJson(Map<String, dynamic> json) =>
      _$ClientRegistrationFromJson(json);

  /// Converts the current client model to a json object/map.
  Map<String, dynamic> toJson() => _$ClientRegistrationToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}
