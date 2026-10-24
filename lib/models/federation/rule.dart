import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/album.dart';
import 'package:mml_admin/models/artist.dart';
import 'package:mml_admin/models/genre.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/federation/peer.dart';
import 'package:mml_admin/models/model_base.dart';

part 'rule.g.dart';

/// Directions a rule is applied to.
abstract class SyncDirection {
  /// Own records sent to the partner.
  static const int outgoing = 1;

  /// Records received from the partner.
  static const int incoming = 2;

  /// Returns the icon of the [direction], which is used for records, rules
  /// and audit log entries.
  static IconData icon(int direction) {
    return direction == outgoing
        ? Symbols.sync_arrow_up
        : Symbols.sync_arrow_down;
  }
}

/// A filter rule which determines the records synchronized with partners.
///
/// The rule applies to all partners or to the partners it is restricted to.
///
/// Values of one criterion are combined with OR, criteria are combined with
/// AND and an empty criterion matches all records.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Rule {
  /// Id of the rule or null if the rule is not created yet.
  final String? ruleId;

  /// The direction the rule is applied to, see [SyncDirection].
  int direction;

  /// The partners the rule is restricted to. Empty applies to all partners.
  List<Peer> peers;

  /// Artists the rule matches.
  List<Artist> artists;

  /// Albums the rule matches.
  List<Album> albums;

  /// Genres the rule matches.
  List<Genre> genres;

  /// For incoming rules the groups received records are assigned to. For
  /// outgoing rules only records in one of these groups match, empty matches
  /// all records.
  List<Group> groups;

  /// Initializes the model.
  Rule({
    this.ruleId,
    required this.direction,
    List<Peer>? peers,
    List<Artist>? artists,
    List<Album>? albums,
    List<Genre>? genres,
    List<Group>? groups,
  }) : peers = peers ?? [],
       artists = artists ?? [],
       albums = albums ?? [],
       genres = genres ?? [],
       groups = groups ?? [];

  /// Converts a json object/map to the model.
  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$RuleToJson(this);

  /// Converts the rule to the request expected by the server.
  Map<String, dynamic> toRequest() {
    return {
      'direction': direction,
      'peers': peers.map((peer) => peer.peerId).toList(),
      'artists': artists.map((artist) => artist.artistId).toList(),
      'albums': albums.map((album) => album.albumId).toList(),
      'genres': genres.map((genre) => genre.genreId).toList(),
      'groups': groups.map((group) => group.id).toList(),
    };
  }

  /// Returns a short description of the criteria of the rule.
  String describe(AppLocalizations locales) {
    var criteria = [
      if (albums.isNotEmpty) '${locales.album}: ${_names(albums)}',
      if (artists.isNotEmpty) '${locales.artist}: ${_names(artists)}',
      if (genres.isNotEmpty) '${locales.genre}: ${_names(genres)}',
      if (direction == SyncDirection.outgoing && groups.isNotEmpty)
        '${locales.groups}: ${_names(groups)}',
    ];

    return criteria.isEmpty ? locales.ruleMatchesAll : criteria.join(' · ');
  }

  /// Indicates whether the rule applies to all partners.
  bool get isGlobal => peers.isEmpty;

  /// Returns the partners the rule applies to.
  String describePeers(AppLocalizations locales) {
    return isGlobal ? locales.ruleAllInstances : _names(peers);
  }

  String _names(List<ModelBase> items) {
    return items.map((item) => item.getDisplayDescription()).join(', ');
  }
}
