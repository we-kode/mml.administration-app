import 'package:flutter/material.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/album.dart';
import 'package:mml_admin/models/artist.dart';
import 'package:mml_admin/models/genre.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_base.dart';

/// A rule which allows the clients of groups to share records.
///
/// Values of one criterion are combined with OR, criteria are combined with
/// AND and an empty criterion matches all records. A rule for all records has
/// no criteria.
class ShareRule extends ModelBase {
  /// Id of the rule or null for a new one.
  final String? id;

  /// Groups whose clients may share the matching records.
  List<Group> groups;

  /// Whether the rule matches all records the groups can access.
  bool allRecords;

  /// Genres the rule matches.
  List<Genre> genres;

  /// Albums the rule matches.
  List<Album> albums;

  /// Artists the rule matches.
  List<Artist> artists;

  /// Initializes the rule.
  ShareRule({
    this.id,
    List<Group>? groups,
    this.allRecords = false,
    List<Genre>? genres,
    List<Album>? albums,
    List<Artist>? artists,
  }) : groups = groups ?? [],
       genres = genres ?? [],
       albums = albums ?? [],
       artists = artists ?? [];

  /// Whether the rule matches all records or has at least one criterion.
  bool get hasCriteria =>
      allRecords ||
      genres.isNotEmpty ||
      albums.isNotEmpty ||
      artists.isNotEmpty;

  /// Converts a json object/map to the model.
  factory ShareRule.fromJson(Map<String, dynamic> json) => ShareRule(
    id: json['id'] as String?,
    groups: List<Group>.from(
      (json['groups'] as List? ?? []).map((e) => Group.fromJson(e)),
    ),
    allRecords: json['allRecords'] as bool? ?? false,
    genres: List<Genre>.from(
      (json['genres'] as List).map((e) => Genre.fromJson(e)),
    ),
    albums: List<Album>.from(
      (json['albums'] as List).map((e) => Album.fromJson(e)),
    ),
    artists: List<Artist>.from(
      (json['artists'] as List).map((e) => Artist.fromJson(e)),
    ),
  );

  /// Converts the rule to the request expected by the server.
  Map<String, dynamic> toRequest() => {
    'id': ?id,
    'groups': groups.map((e) => e.id).toList(),
    'allRecords': allRecords,
    'genres': genres.map((e) => e.genreId).toList(),
    'albums': albums.map((e) => e.albumId).toList(),
    'artists': artists.map((e) => e.artistId).toList(),
  };

  @override
  String getDisplayDescription() {
    return [
      genres.map((e) => e.getDisplayDescription()).join(', '),
      albums.map((e) => e.getDisplayDescription()).join(', '),
      artists.map((e) => e.getDisplayDescription()).join(', '),
    ].where((e) => e.isNotEmpty).join(' · ');
  }

  @override
  dynamic getIdentifier() {
    return id;
  }

  @override
  String? getSubtitle(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    if (allRecords) {
      return locales.shareAllRecords;
    }

    return [
      if (genres.isNotEmpty) locales.genre,
      if (albums.isNotEmpty) locales.album,
      if (artists.isNotEmpty) locales.artist,
    ].join(' · ');
  }

  @override
  List<ModelBase>? getTags() {
    return groups;
  }
}
