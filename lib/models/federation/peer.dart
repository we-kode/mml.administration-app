import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/peer_state.dart';
import 'package:mml_admin/models/model_base.dart';

part 'peer.g.dart';

/// A partner instance records are synchronized with.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Peer extends ModelBase {
  /// Id of the partner.
  final String peerId;

  /// The unique instance name of the partner.
  final String instance;

  /// The public base url of the partner.
  final String baseUrl;

  /// The registration state of the partner, see [PeerState].
  final int state;

  /// Date when the public keys of the partner were loaded the last time.
  final DateTime? jwksUpdatedAt;

  /// Date when the partner was created.
  final DateTime? createdAt;

  /// Initializes the model.
  Peer({
    required this.peerId,
    required this.instance,
    required this.baseUrl,
    required this.state,
    this.jwksUpdatedAt,
    this.createdAt,
    super.isDeletable,
  });

  /// Converts a json object/map to the model.
  factory Peer.fromJson(Map<String, dynamic> json) => _$PeerFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$PeerToJson(this);

  /// Indicates whether the partner waits for the approval of the admin.
  bool get isPendingApproval => state == PeerState.pendingApproval;

  /// Indicates whether rules can be maintained for the partner.
  bool get hasRules =>
      state == PeerState.linked || state == PeerState.responsePending;

  /// Returns the translated name of the registration state.
  String stateName(AppLocalizations locales) {
    switch (state) {
      case PeerState.requested:
        return locales.peerStateRequested;
      case PeerState.pendingApproval:
        return locales.peerStatePendingApproval;
      case PeerState.responsePending:
        return locales.peerStateResponsePending;
      case PeerState.linked:
        return locales.peerStateLinked;
      default:
        return locales.peerStateRejected;
    }
  }

  @override
  String getDisplayDescription() {
    return instance;
  }

  @override
  dynamic getIdentifier() {
    return peerId;
  }

  @override
  String? getSubtitle(BuildContext context) {
    return baseUrl;
  }

  @override
  String? getMetadata(BuildContext context) {
    return stateName(AppLocalizations.of(context)!);
  }

  @override
  String? getSubMetadata(BuildContext context) {
    return createdAt != null
        ? DateFormat.yMd().add_Hm().format(createdAt!.toLocal())
        : null;
  }

  @override
  Icon? getPrefixIcon(BuildContext context) {
    switch (state) {
      case PeerState.linked:
        return const Icon(Symbols.link);
      case PeerState.pendingApproval:
        return Icon(
          Symbols.notification_important,
          color: Theme.of(context).colorScheme.secondary,
        );
      default:
        return const Icon(Symbols.hourglass_empty);
    }
  }
}
