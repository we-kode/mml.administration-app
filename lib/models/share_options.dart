/// Options of a share link.
class ShareOptions {
  /// The validities in hours an admin can choose from.
  static const List<int> validForHoursChoices = [1, 24, 168, 720, 2160];

  /// The largest number of records in one share link.
  static const int maxRecordsPerLink = 200;

  /// Validity of the link in hours.
  int validForHours;

  /// Whether the link can be used only once.
  bool singleUse;

  /// Initializes the options with the longest validity and a single use link.
  ShareOptions({this.validForHours = 2160, this.singleUse = true});
}
