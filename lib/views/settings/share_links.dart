import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/view_models/settings/share_links.dart';
import 'package:provider/provider.dart';

/// Dialog that lists the active share links of the admin and deletes them.
class ShareLinksScreen extends StatelessWidget {
  /// Initializes the instance.
  const ShareLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShareLinksViewModel>(
      create: (context) => ShareLinksViewModel(),
      builder: (context, _) {
        var vm = Provider.of<ShareLinksViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;
        var format = DateFormat.yMd().add_Hm();

        return AlertDialog(
          title: Text(locales.shareMyLinks),
          content: SizedBox(
            width: 480,
            child: FutureBuilder(
              future: vm.init(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [CircularProgressIndicator()],
                  );
                }

                return Consumer<ShareLinksViewModel>(
                  builder: (context, vm, _) {
                    if (vm.links.isEmpty) {
                      return Text(locales.shareNoLinks);
                    }

                    return ListView(
                      shrinkWrap: true,
                      children: [
                        for (var link in vm.links)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              '${locales.shareLinkRecords(link.recordCount)}'
                              '${link.singleUse ? ' · ${locales.shareSingleUse}' : ''}',
                            ),
                            subtitle: Text(
                              '${locales.shareLinkCreatedAt(format.format(link.createdAt.toLocal()))}\n'
                              '${locales.invitationExpiresAt(format.format(link.expiresAt.toLocal()))}',
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Symbols.delete),
                              tooltip: locales.remove,
                              onPressed: () => vm.delete(context, link),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(locales.close),
            ),
          ],
        );
      },
    );
  }
}
