import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/announcement_severity.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_base.dart';

part 'announcement.g.dart';

/// Message of the admins shown to the clients, e.g. an announcement of a
/// maintenance. Without groups and clients it is shown to all clients.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Announcement extends ModelBase {
  /// Id of the announcement or null for a new one.
  final String? notificationId;

  /// Title of the announcement.
  String? title;

  /// Plain text message of the announcement.
  String? message;

  /// Severity of the announcement, see [AnnouncementSeverity].
  int severity;

  /// Start of the validity or null, if it is valid immediately.
  DateTime? validFrom;

  /// End of the validity or null, if it is valid until it is deleted.
  DateTime? validTo;

  /// Time of the last change.
  @JsonKey(includeToJson: false)
  DateTime? updatedAt;

  /// Ids of the clients the announcement is shown to.
  List<String> clientIds = [];

  /// Groups whose clients the announcement is shown to.
  List<Group> groups = [];

  /// Initializes the model.
  Announcement({
    this.notificationId,
    this.title,
    this.message,
    this.severity = AnnouncementSeverity.info,
    this.validFrom,
    this.validTo,
    this.updatedAt,
    List<String>? clientIds,
    List<Group>? groups,
    super.isDeletable,
  }) {
    this.clientIds = clientIds ?? [];
    this.groups = groups ?? [];
  }

  /// Converts a json object/map to the model.
  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  /// Converts the current model to a json object/map. Dates are sent in UTC.
  Map<String, dynamic> toJson() => {
    ..._$AnnouncementToJson(this),
    'validFrom': ?validFrom?.toUtc().toIso8601String(),
    'validTo': ?validTo?.toUtc().toIso8601String(),
  };

  /// Whether the announcement is valid at the given time [now].
  bool isActive(DateTime now) =>
      (validFrom == null || !validFrom!.isAfter(now)) &&
      (validTo == null || !validTo!.isBefore(now));

  @override
  String getDisplayDescription() {
    return title ?? '';
  }

  @override
  dynamic getIdentifier() {
    return notificationId;
  }

  @override
  String? getSubtitle(BuildContext context) {
    return message?.split('\n').first;
  }

  @override
  String? getSubtitleNote(BuildContext context) {
    return isActive(DateTime.now())
        ? AppLocalizations.of(context)!.announcementActive
        : null;
  }

  @override
  String? getMetadata(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    if (validFrom == null && validTo == null) {
      return locales.validUntilDeleted;
    }

    var format = DateFormat.yMd().add_Hm();
    var from = validFrom != null ? format.format(validFrom!.toLocal()) : '';
    var to = validTo != null ? format.format(validTo!.toLocal()) : '';
    return '$from – $to';
  }

  @override
  Icon? getPrefixIcon(BuildContext context) {
    return Icon(AnnouncementSeverity.icon(severity));
  }

  @override
  List<ModelBase>? getTags() {
    return groups;
  }
}
