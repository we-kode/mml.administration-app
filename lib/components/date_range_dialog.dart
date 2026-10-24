import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';

/// Shows a dialog to select a range of days up to today, starting with the
/// [initial] range. Returns null if the dialog was canceled.
Future<DateTimeRange?> showDateRangeDialog(
  BuildContext context, {
  DateTimeRange? initial,
}) async {
  var locales = AppLocalizations.of(context)!;
  var dates = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      lastDate: DateTime.now(),
      cancelButton: Text(
        locales.cancel,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      okButton: Text(
        locales.save,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    ),
    dialogSize: Size(
      MediaQuery.of(context).size.height * 0.4,
      MediaQuery.of(context).size.width * 0.2,
    ),
    borderRadius: BorderRadius.circular(0),
    value: [initial?.start, initial?.end],
  );

  if (dates == null || dates.isEmpty) {
    return null;
  }

  return DateTimeRange(start: dates.first!, end: dates.last!);
}
