/// An extension to validate strings whether they contain a valid guid or not.
extension IsValidGuid on String {
  /// Returns a boolean, that indicates, whether the string contains a valid
  /// guid or not.
  bool isValidGuid() {
    return RegExp(r'^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$').hasMatch(this);
  }
}
