/// Result of the creation of a share link.
class ShareResponse {
  /// The download url of the link.
  final String url;

  /// Number of the shared records.
  final int shared;

  /// Number of the requested records, that were not shared.
  final int skipped;

  /// Initializes the response.
  const ShareResponse({
    required this.url,
    required this.shared,
    required this.skipped,
  });
}
