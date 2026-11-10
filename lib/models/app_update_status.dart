/// State of the app update process.
enum AppUpdateStatus {
  /// The latest release is being loaded.
  checking,

  /// The app is up to date or no update repository is configured.
  upToDate,

  /// A newer release is available.
  available,

  /// The installer of the newer release is being downloaded.
  downloading,

  /// The download of the installer failed and can be started again.
  downloadFailed,

  /// The update was postponed or its installer was opened.
  dismissed,

  /// The latest release could not be loaded.
  error,
}
