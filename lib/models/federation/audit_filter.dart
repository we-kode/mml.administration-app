import 'package:flutter/material.dart';
import 'package:mml_admin/models/federation/audit_sort.dart';
import 'package:mml_admin/models/federation/sync_direction.dart';

/// Column filters and sort order of the federation audit log. Listeners are
/// notified whenever the entries have to be reloaded.
class AuditFilter extends ChangeNotifier {
  Set<int> _statuses = {};
  Set<int> _actions = {};
  Set<int> _directions = {};
  Set<String> _instances = {};
  DateTimeRange? _dates;
  String? _message;
  final List<AuditSort> _sort = [];

  /// Only entries with one of these statuses are loaded, all if empty, see
  /// [AuditStatus].
  Set<int> get statuses => Set.unmodifiable(_statuses);

  /// Only entries with one of these actions are loaded, all if empty, see
  /// [AuditAction].
  Set<int> get actions => Set.unmodifiable(_actions);

  /// Only entries of these directions are loaded, all if empty, see
  /// [SyncDirection].
  Set<int> get directions => Set.unmodifiable(_directions);

  /// Only entries concerning one of these partner instances are loaded, all
  /// if empty.
  Set<String> get instances => Set.unmodifiable(_instances);

  /// Only entries created within these local days are loaded if set.
  DateTimeRange? get dates => _dates;

  /// Only entries whose message contains this text are loaded if set.
  String? get message => _message;

  /// The columns the entries are sorted by in order of priority. The server
  /// sorts the entries newest first if empty.
  List<AuditSort> get sort => List.unmodifiable(_sort);

  /// Whether at least one column filter is set. The [message] is not a column
  /// filter.
  bool get isActive =>
      _statuses.isNotEmpty ||
      _actions.isNotEmpty ||
      _directions.isNotEmpty ||
      _instances.isNotEmpty ||
      _dates != null;

  /// Sets the statuses to filter by.
  set statuses(Iterable<int> statuses) {
    _statuses = statuses.toSet();
    notifyListeners();
  }

  /// Sets the actions to filter by.
  set actions(Iterable<int> actions) {
    _actions = actions.toSet();
    notifyListeners();
  }

  /// Sets the directions to filter by.
  set directions(Iterable<int> directions) {
    _directions = directions.toSet();
    notifyListeners();
  }

  /// Sets the partner instances to filter by.
  set instances(Iterable<String> instances) {
    _instances = instances.toSet();
    notifyListeners();
  }

  /// Sets the local days the entries were created in, removes the filter if
  /// null.
  set dates(DateTimeRange? dates) {
    _dates = dates;
    notifyListeners();
  }

  /// Sets the text the message has to contain, removes the filter if empty.
  set message(String? message) {
    var value = message?.trim();
    _message = value?.isEmpty ?? true ? null : value;
    notifyListeners();
  }

  /// Returns the sort order of the [field] and its priority starting at 1,
  /// or null if the entries are not sorted by the [field].
  ({int priority, bool descending})? sortOf(String field) {
    var index = _sort.indexWhere((s) => s.field == field);
    return index < 0
        ? null
        : (priority: index + 1, descending: _sort[index].descending);
  }

  /// Switches the sort order of the [field] from ascending to descending to
  /// not sorted. A newly sorted field gets the lowest priority.
  void cycleSort(String field) {
    var index = _sort.indexWhere((s) => s.field == field);
    if (index < 0) {
      _sort.add((field: field, descending: false));
    } else if (!_sort[index].descending) {
      _sort[index] = (field: field, descending: true);
    } else {
      _sort.removeAt(index);
    }
    notifyListeners();
  }

  /// Removes all column filters. The message and the sort order are kept.
  void reset() {
    _statuses = {};
    _actions = {};
    _directions = {};
    _instances = {};
    _dates = null;
    notifyListeners();
  }

  /// Returns the query parameters of the filter for the server.
  Map<String, dynamic> toQuery() {
    return {
      if (_statuses.isNotEmpty) 'status': _statuses.toList(),
      if (_actions.isNotEmpty) 'action': _actions.toList(),
      if (_directions.length == 1) 'direction': _directions.first,
      if (_instances.isNotEmpty) 'instance': _instances.toList(),
      if (_dates != null) ...{
        'from': _dates!.start.toUtc().toIso8601String(),
        'to': DateUtils.addDaysToDate(
          DateUtils.dateOnly(_dates!.end),
          1,
        ).toUtc().toIso8601String(),
      },
      'message': ?_message,
      if (_sort.isNotEmpty)
        'sort': [for (var s in _sort) '${s.descending ? '-' : ''}${s.field}'],
    };
  }
}
