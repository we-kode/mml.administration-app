import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Shows a date and time, which can be changed with a date and a time picker.
class DateTimeField extends StatelessWidget {
  /// Label of the field.
  final String label;

  /// The selected date and time.
  final DateTime? value;

  /// Called with the new date and time chosen by the user.
  final ValueChanged<DateTime> onChanged;

  /// Initializes the field.
  const DateTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Symbols.event),
      title: Text(label),
      subtitle: Text(
        value != null ? DateFormat.yMd().add_Hm().format(value!) : '',
      ),
      onTap: () => _pick(context),
    );
  }

  Future<void> _pick(BuildContext context) async {
    var initial = value ?? DateTime.now();
    var date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(9999),
    );
    if (date == null || !context.mounted) {
      return;
    }

    var time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) {
      return;
    }

    onChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }
}
