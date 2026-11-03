import 'package:mml_admin/models/share_options.dart';

/// Server settings that control the share links of clients.
class ShareSettings {
  /// The days an admin can choose to keep shared searches.
  static const List<int> searchLinkRetentionChoices = [7, 30, 90, 180, 365];

  /// The days shared searches are kept by default.
  static const int defaultSearchLinkRetentionDays = 30;

  /// Whether clients choose validity and usage of their links themselves.
  bool userSettingsAllowed;

  /// Options of the links of clients, if they cannot choose.
  ShareOptions userOptions;

  /// Days a shared search is kept after it was opened the last time.
  int searchLinkRetentionDays;

  /// Initializes the settings.
  ShareSettings({
    this.userSettingsAllowed = false,
    ShareOptions? userOptions,
    this.searchLinkRetentionDays = defaultSearchLinkRetentionDays,
  }) : userOptions = userOptions ?? ShareOptions();

  /// Converts a json object/map to the model.
  factory ShareSettings.fromJson(Map<String, dynamic> json) => ShareSettings(
    userSettingsAllowed: json['userSettingsAllowed'] as bool? ?? false,
    userOptions: ShareOptions(
      validForHours: json['userValidForHours'] as int? ?? 2160,
      singleUse: json['userSingleUse'] as bool? ?? true,
    ),
    searchLinkRetentionDays:
        json['searchLinkRetentionDays'] as int? ??
        defaultSearchLinkRetentionDays,
  );

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => {
    'userSettingsAllowed': userSettingsAllowed,
    'userValidForHours': userOptions.validForHours,
    'userSingleUse': userOptions.singleUse,
    'searchLinkRetentionDays': searchLinkRetentionDays,
  };
}
