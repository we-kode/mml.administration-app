import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

part 'client.g.dart';

/// Client model that holds all information of a client.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Client extends ModelBase {
  /// Id of the client.
  final String? clientId;

  /// Display name of the client.
  String? displayName;

  /// The device identifier of the client.
  String? deviceIdentifier;

  /// The date and time the client requested a new token.
  DateTime? lastTokenRefreshDate;

  /// List of groups the client is assigned to.
  List<Group> groups = [];

  /// Creates a new client instance with the given values.
  Client({
    required this.clientId,
    this.displayName,
    this.deviceIdentifier,
    this.lastTokenRefreshDate,
    bool isDeletable = true,
    List<Group>? groups,
  }) : super(isDeletable: isDeletable) {
    this.groups = groups ?? [];
  }

  /// Converts a json object/map to the client model.
  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  /// Converts the current client model to a json object/map.
  Map<String, dynamic> toJson() => _$ClientToJson(this);

  @override
  String getDisplayDescription() {
    return "$displayName";
  }

  @override
  String getDisplayDescriptionSuffix(BuildContext context) {
    return "$deviceIdentifier";
  }

  @override
  dynamic getIdentifier() {
    return clientId;
  }

  @override
  String? getSubtitle(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    return locales
        .lastTokenRefresh(DateFormat().format(lastTokenRefreshDate!.toLocal()));
  }

  @override
  List<ModelBase>? getTags() {
    return groups;
  }

  @override
  Widget? getAvatar(BuildContext context) {
    if (deviceIdentifier!.startsWith(RegExp(r'i[p|P]hone'))) {
      return const Icon(Icons.phone_iphone);
    } else if (deviceIdentifier!.startsWith(RegExp(r'i[p|P]ad'))) {
      return const Icon(Icons.tablet_mac);
    }

    return const Icon(Icons.phone_android);
  }
}
