import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'connection_settings.g.dart';

/// Model that holds all server connection settings for a client app.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ConnectionSettings {
  /// Api-Key that is used for the apps.
  String apiKey;

  /// Name of the server that handles the app requests.
  String serverName;

  /// Initializes the model.
  ConnectionSettings({required this.apiKey, required this.serverName});

  /// Converts a json object/map to the model.
  factory ConnectionSettings.fromJson(Map<String, dynamic> json) =>
      _$ConnectionSettingsFromJson(json);

  /// Converts the model to a json object/map.
  Map<String, dynamic> toJson() => _$ConnectionSettingsToJson(this);

  @override
  String toString() {
    try {
      return base64Encode(utf8.encode(jsonEncode(toJson())));
    } on FormatException catch (_) {
      return "";
    }
  }
}
