import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/model_base.dart';

part 'invitation.g.dart';

/// Hours an invitation can stay valid. The first value is the default.
const List<int> invitationValidities = [24, 3 * 24, 7 * 24, 30 * 24, 90 * 24];

/// A one-time code a partner must present to request a registration.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Invitation extends ModelBase {
  /// Id of the invitation.
  final String invitationId;

  /// The code of the invitation. Only available when the invitation is
  /// created.
  final String? code;

  /// The public address of this instance, which the partner needs together
  /// with the code. Only available when the invitation is created.
  final String? baseUrl;

  /// Date when the invitation was created.
  final DateTime createdAt;

  /// Date when the invitation expires.
  final DateTime expiresAt;

  /// Initializes the model.
  Invitation({
    required this.invitationId,
    required this.createdAt,
    required this.expiresAt,
    this.code,
    this.baseUrl,
    super.isDeletable,
  });

  /// Converts a json object/map to the model.
  factory Invitation.fromJson(Map<String, dynamic> json) =>
      _$InvitationFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$InvitationToJson(this);

  @override
  String getDisplayDescription() {
    return DateFormat.yMd().add_Hm().format(createdAt.toLocal());
  }

  @override
  dynamic getIdentifier() {
    return invitationId;
  }

  @override
  String? getSubtitle(BuildContext context) {
    return AppLocalizations.of(context)!.invitationExpiresAt(
      DateFormat.yMd().add_Hm().format(expiresAt.toLocal()),
    );
  }

  @override
  Icon? getPrefixIcon(BuildContext context) {
    return const Icon(Symbols.key);
  }
}
