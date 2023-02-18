import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/models/model_base.dart';

part 'genre_bitrate.g.dart';

/// Genre model that holds all informations of a record genre.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GenreBitrate extends ModelBase {
  /// Id of the genre.
  final String? genreId;

  /// Name of the genre.
  String? name;

  /// Compression bitrate of the genre.
  int? bitrate;

  /// Initializes the model.
  GenreBitrate({
    this.genreId,
    this.name,
    this.bitrate,
    bool isDeletable = true,
  }) : super(isDeletable: isDeletable);

  /// Converts a json object/map to the model.
  factory GenreBitrate.fromJson(Map<String, dynamic> json) =>
      _$GenreBitrateFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$GenreBitrateToJson(this);

  @override
  String getDisplayDescription() {
    return "$name";
  }

  @override
  getIdentifier() {
    return "$genreId";
  }
}
