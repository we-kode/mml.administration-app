/// State of the app update process.
enum AppUpdateStatus {
  checking,
  upToDate,
  available,
  downloading,
  readyToInstall,
  dismissed,
  error,
}
