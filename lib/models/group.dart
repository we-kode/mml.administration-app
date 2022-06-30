import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/models/model_base.dart';

part 'group.g.dart';

///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Group extends ModelBase {
  ///
  final String? id;

  ///
  String? name;

  ///
  bool isDefault;

  ///
  Group({
    this.id,
    this.name,
    this.isDefault = false,
    bool isDeletable = true
  }) : super(isDeletable: isDeletable);

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
