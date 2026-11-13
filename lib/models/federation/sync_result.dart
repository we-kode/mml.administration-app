/// Result of a manual synchronization.
class SyncResult {
  /// Count of transfers queued for partners.
  final int queued;

  /// Count of records skipped, because they are received from a partner,
  /// already sent or match no rule.
  final int skipped;

  /// Initializes the model.
  const SyncResult(this.queued, this.skipped);

  /// Converts a json object/map to the model.
  factory SyncResult.fromJson(Map<String, dynamic> json) =>
      SyncResult(json['queued'] ?? 0, json['skipped'] ?? 0);
}
