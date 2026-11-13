import 'package:material_ui/material_ui.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/share_link.dart';
import 'package:mml_admin/services/share.dart';

/// View model for the dialog, that manages the active share links of the admin.
class ShareLinksViewModel extends ChangeNotifier {
  /// [ShareService] used to load and delete the links.
  final ShareService _service = ShareService.getInstance();

  /// Active links of the admin.
  List<ShareLink> links = [];

  /// Loads the active links.
  Future<bool> init() async {
    try {
      links = await _service.getLinks();
    } catch (_) {
      // Errors are shown by the api service.
    }

    return true;
  }

  /// Deletes the [link] after the admin confirmed it.
  Future<void> delete(BuildContext context, ShareLink link) async {
    var message = AppLocalizations.of(context)!.shareLinkDeleteInfo;
    if (!await showDeleteDialog(context, message: message)) {
      return;
    }

    try {
      await _service.deleteLink(link.id);
      links.remove(link);
      notifyListeners();
    } catch (_) {
      // Errors are shown by the api service.
    }
  }
}
