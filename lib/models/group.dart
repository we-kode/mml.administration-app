import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/models/model_base.dart';

part 'group.g.dart';

/// Group model that holds all information of a client group.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Group extends ModelBase {
  /// Id of the group.
  final String? id;

  /// Name of the group.
  String? name;

  /// Flag, that indicates, whether the client group is a default group or not.
  bool isDefault;

  /// Initializes the group model.
  Group({
    this.id,
    this.name,
    this.isDefault = false,
    super.isDeletable
  });

  /// Converts a json object/map to the group model.
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  /// Converts the current group model to a json object/map.
  Map<String, dynamic> toJson() => _$GroupToJson(this);

  @override
  String getDisplayDescription() {
    return "$name";
  }

  @override
  dynamic getIdentifier() {
    return id;
  }

  @override
  bool operator==(Object other) {
    return other is Group && other.id != null && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
