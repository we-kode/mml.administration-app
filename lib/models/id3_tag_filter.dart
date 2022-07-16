import 'package:json_annotation/json_annotation.dart';

part 'id3_tag_filter.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ID3TagFilter {
  List<String> artists = [];

  List<String> genres = [];

  List<String> albums = [];

  DateTime? startDate;

  DateTime? endDate;

  ID3TagFilter({
    List<String>? artists,
    List<String>? genres,
    List<String>? albums,
    this.startDate,
    this.endDate
  }) {
    this.artists = artists ?? [];
    this.genres = genres ?? [];
    this.albums = albums ?? [];
  }

  /// Converts a json object/map to the record model.
  factory ID3TagFilter.fromJson(Map<String, dynamic> json) => _$ID3TagFilterFromJson(json);

  /// Converts the current record model to a json object/map.
  Map<String, dynamic> toJson() => _$ID3TagFilterToJson(this);
}
