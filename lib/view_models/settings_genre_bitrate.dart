import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/services/router.dart';

class SettingsGenreBitrateviewModel extends ChangeNotifier {
  /// Current build context.
  late BuildContext _context;

  /// Key of the user edit form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Initialize the registration client view model.
  Future<bool> init(BuildContext context) async {
    _context = context;

    /// TODO load genres bitrates
    return true;
  }

  /// Updates the registered client or aborts, if the user cancels the operation.
  void save() async {
    var nav = Navigator.of(_context);

    showProgressIndicator();

    // formKey.currentState!.save();

    var shouldClose = false;

    // try {
    //   await _service.updateClient(client!);
    //   shouldClose = true;
    // } on DioError catch (e) {
    //   var statusCode = e.response?.statusCode;

    //   if (statusCode == HttpStatus.notFound) {
    //     var messenger = MessengerService.getInstance();
    //     messenger.showMessage(messenger.notFound);
    //     shouldClose = true;
    //   }
    // } finally {
    //   RouterService.getInstance().navigatorKey.currentState!.pop();

    //   if (shouldClose) {
    //     nav.pop(true);
    //   }
    // }
    // TODO save all list of bitrates
    RouterService.getInstance().navigatorKey.currentState!.pop();
    nav.pop(true);
  }

  // TODO remove bitrate from genre
  // TODO create new bitrate for genre

  /// Closes the view if user aborts registration view.
  void abort() async {
    var nav = Navigator.of(_context);
    showProgressIndicator();
    RouterService.getInstance().navigatorKey.currentState!.pop();
    nav.pop(false);
  }

  void add() {
    print('add');
  }
}
