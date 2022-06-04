import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/models/model_base.dart';

part 'client.g.dart';

/// Client model that holds all information of an client.
@JsonSerializable(includeIfNull: false)
class Client extends ModelBase {
  /// Id of the client.
  final String? clientId;

  /// Display name of the client.
  String? displayName;

  /// Creates a new client instance with the given values.
  Client({this.clientId, this.displayName, bool isDeletable = true})
      : super(isDeletable: isDeletable);

  /// Converts a json object/map to the client model.
  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  /// Converts the current client model to a json object/map.
  Map<String, dynamic> toJson() => _$ClientToJson(this);

  @override
  String getDisplayDescription() {
    return displayName!;
  }

  @override
  getIdentifier() {
    return clientId;
  }
}
