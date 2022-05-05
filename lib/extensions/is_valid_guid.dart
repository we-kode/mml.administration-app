extension IsValidGuid on String {
  bool isValidGuid() {
    return RegExp(r'^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$').hasMatch(this);
  }
}
