import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/genre_bitrate.dart';
import 'package:mml_admin/services/record.dart';
import 'package:mml_admin/services/router.dart';

class SettingsGenreBitrateViewModel extends ChangeNotifier {
  /// [RecordService] used to load data of the record settings.
  final RecordService _recordService = RecordService.getInstance();

  /// Current build context.
  late BuildContext _context;

  /// Available bitrates.
  // List<GenreBitrate> bitrates = List.empty(growable: true);
  List<GenreBitrate> bitrates = List.empty(growable: true);

  /// Initialize the registration client view model.
  Future<bool> init(BuildContext context) async {
    return Future<bool>.microtask(() async {
      _context = context;
      try {
        bitrates = await _recordService.loadBitrates();
      } catch (e) {
        // Catch all errors and do nothing, since handled by api service!
      }
      return true;
    });
  }

  /// Removes one element at [index].
  Future<void> remove(int index) async {
    final bitrate = bitrates[index];
    if (bitrate.genreId != null && bitrate.genreId!.isNotEmpty) {
      try {
        await _recordService.deleteBitrate(bitrate);
      } catch (e) {
        // Catch all errors and do nothing, since handled by api service!
      }
    }

    bitrates.removeAt(index);
    notifyListeners();
  }

  /// Adds one new element.
  Future<void> add() async {
    bitrates.add(GenreBitrate());
    notifyListeners();
  }

  /// Updates the registered client or aborts, if the user cancels the operation.
  void save() async {
    var nav = Navigator.of(_context);

    showProgressIndicator();

    var shouldClose = false;

    try {
      await _recordService.updateBitrates(bitrates);
      shouldClose = true;
    } catch (e) {
      // Catch all errors and do nothing, since handled by api service!
    } finally {
      RouterService.getInstance().navigatorKey.currentState!.pop();

      if (shouldClose) {
        nav.pop(true);
      }
    }
  }

  /// Closes the view if user aborts registration view.
  void abort() async {
    var nav = Navigator.of(_context);
    showProgressIndicator();
    RouterService.getInstance().navigatorKey.currentState!.pop();
    nav.pop(false);
  }
}
