import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

/// Settings model that holds all information of the Uplaod settinmgs.
@JsonSerializable(includeIfNull: false)
class Settings {
  /// The compression rate of one record in kbit/s.
  int? compressionRate;

  /// Initializes the model.
  Settings({
    this.compressionRate,
  });

  /// Converts a json object/map to the model.
  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
