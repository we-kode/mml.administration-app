import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/tag.dart';

part 'livestream.g.dart';

/// Livestream model that holds all information of a livestream.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Livestream extends ModelBase {
  /// Id of the livestream.
  final String? recordId;

  /// Name to be displayed.
  String? title;

  /// The internal url of the streaming provider endpoint.
  String? url;

  /// List of groups associated with this livestream.
  List<Group> groups = [];

  /// Initializes the model.
  Livestream({
    this.recordId,
    this.title,
    this.url,
    List<Group>? groups,
    bool isDeletable = true,
  }) : super(isDeletable: isDeletable) {
    this.groups = groups ?? [];
  }

  /// Converts a json object/map to the model.
  factory Livestream.fromJson(Map<String, dynamic> json) =>
      _$LivestreamFromJson(json);

  /// Converts the current record model to a json object/map.
  Map<String, dynamic> toJson() => _$LivestreamToJson(this);

  @override
  String getDisplayDescription() {
    return title ?? "";
  }

  @override
  getIdentifier() {
    return recordId ?? "";
  }

  @override
  List<Tag>? getTags() {
    return groups.map((g) => Tag(name: g.name ?? "")).toList();
  }
}
