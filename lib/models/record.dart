import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/components/shimmer_cover.dart';
import 'package:mml_admin/extensions/datetime.dart';
import 'package:mml_admin/extensions/flag.dart';
import 'package:mml_admin/manager/image_cache_manager.dart';
import 'package:mml_admin/models/federation/record_sync.dart';
import 'package:mml_admin/models/federation/rule.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';

part 'record.g.dart';

/// Record model that holds all information of a record.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Record extends ModelBase {
  /// Id of the client.
  final String? recordId;

  /// Title of the record.
  String? title;

  /// Track number of the record.
  int? trackNumber;

  /// The date the record was created..
  DateTime? date;

  /// The duration of the record in milliseconds.
  double duration;

  /// The artists or null if no one provided.
  String? artist;

  /// Genre of the record or null if no one provided.
  String? genre;

  /// Album of the record or null if no one provided.
  String? album;

  /// Language of the record or null if no one provided.
  String? language;

  /// The bitrate in kbit/s of the record.
  int? bitrate;

  /// The file name of the cover image of the record. It is managed by the
  /// server and not sent on updates.
  @JsonKey(includeToJson: false)
  String? cover;

  /// The owner of the record.
  String ownerInstance;

  /// The synchronization state with partner instances, see
  /// [RecordSyncState]. Only set in lists of records.
  @JsonKey(includeToJson: false)
  int syncState;

  /// Indicates whether the record is locked for some operations on records..
  bool? locked;

  /// List of groups the client is assigned to.
  List<Group> groups = [];

  /// Creates a new record instance with the given values.
  Record({
    required this.recordId,
    required this.ownerInstance,
    this.title,
    this.trackNumber,
    this.date,
    this.duration = 0,
    this.album,
    this.artist,
    this.genre,
    this.language,
    this.bitrate,
    this.cover,
    this.locked,
    super.isDeletable,
    List<Group>? groups,
    this.syncState = RecordSyncState.none,
  }) {
    this.groups = groups ?? [];
  }

  /// Converts a json object/map to the record model.
  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  /// Converts the current record model to a json object/map.
  Map<String, dynamic> toJson() => _$RecordToJson(this);

  @override
  String getDisplayDescription() {
    final tn = trackNumber != null ? '$trackNumber - ' : '';
    return "$tn$title";
  }

  @override
  dynamic getIdentifier() {
    return recordId;
  }

  @override
  String? getSubtitle(BuildContext context) {
    return artist ?? AppLocalizations.of(context)!.unknown;
  }

  @override
  String? getSubtitleNote(BuildContext context) {
    return syncState == RecordSyncState.received
        ? AppLocalizations.of(context)!.receivedFrom(ownerInstance)
        : null;
  }

  @override
  String? getMetadata(BuildContext context) {
    int seconds = ((duration / 1000) % 60).toInt();
    int minutes = ((duration / (1000 * 60)) % 60).toInt();
    int hours = ((duration / (1000 * 60 * 60)) % 24).toInt();
    return "${_valueString(hours)}:${_valueString(minutes)}:${_valueString(seconds)}";
  }

  @override
  String? getSubMetadata(BuildContext context) {
    var g = genre ?? '';

    var lang = '';
    if (language != null) {
      lang = "${language?.asFlag().join(' ')}";
    }

    return "$g${lang.isEmpty ? '' : ' '}$lang";
  }

  @override
  List<ModelBase>? getTags() {
    return groups;
  }

  @override
  String? getGroup(BuildContext context) {
    return '${DateFormat.yMd().format(date!)} - ${date!.weekdayName()}${album?.isNotEmpty ?? false ? ':' : ''} $album';
  }

  @override
  String? getDisplayDescriptionSuffix(BuildContext context) {
    return bitrate != null ? "$bitrate kbit/s" : null;
  }

  @override
  Widget? getAvatar(BuildContext context) {
    if (cover != null && cover!.isNotEmpty) {
      return CachedNetworkImage(
        cacheKey: cover,
        imageUrl: cover!,
        placeholder: (context, url) => const ShimmerCover(),
        errorWidget: (context, url, error) => const Icon(Symbols.music_note_2),
        cacheManager: ImageCacheManager(),
      );
    }
    return const Icon(Symbols.music_note);
  }

  @override
  Widget? getSecureState(BuildContext context) {
    var isLocked = locked ?? false;
    var syncIcon = _syncIcon(context);
    if (!isLocked && syncIcon == null) {
      return null;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ?syncIcon,
        if (isLocked)
          Icon(
            Symbols.block,
            size: 10,
            color: Theme.of(context).colorScheme.error,
          ),
      ],
    );
  }

  /// Returns the icon of the synchronization state or null for records,
  /// which are not synchronized.
  Widget? _syncIcon(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var colors = Theme.of(context).colorScheme;
    var (icon, color, message) = switch (syncState) {
      RecordSyncState.received => (
        SyncDirection.icon(SyncDirection.incoming),
        colors.secondary,
        locales.receivedFrom(ownerInstance),
      ),
      RecordSyncState.sent => (
        SyncDirection.icon(SyncDirection.outgoing),
        colors.primary,
        locales.syncStateSent,
      ),
      RecordSyncState.problem => (
        Symbols.sync_problem,
        colors.error,
        locales.syncStateProblem,
      ),
      _ => (null, null, null),
    };
    if (icon == null) {
      return null;
    }

    return Tooltip(
      message: message,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  /// Adds a 0 before [value] if [value] is smaller than ten.
  String _valueString(int value) {
    return value < 10 ? "0$value" : "$value";
  }
}
