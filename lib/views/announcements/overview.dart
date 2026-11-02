import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/announcement.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/view_models/announcements/overview.dart';
import 'package:mml_admin/views/announcements/edit.dart';
import 'package:provider/provider.dart';

/// Overview screen of the announcements shown to the clients.
class AnnouncementsScreen extends StatelessWidget {
  /// Initializes the instance.
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnnouncementsViewModel>(
      create: (context) => AnnouncementsViewModel(),
      builder: (context, _) {
        var vm = Provider.of<AnnouncementsViewModel>(context, listen: false);

        return FutureBuilder(
          future: vm.init(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!vm.isSupported) {
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.announcementsNotSupported,
                ),
              );
            }

            return AsyncListView(
              deleteItems: <T>(List<T> items) => vm.delete(context, items),
              addItem: () async =>
                  await showDialog<bool>(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) =>
                        const AnnouncementEditDialog(id: null),
                  ) ??
                  false,
              editItem: (ModelBase item, Subfilter? subfilter) async =>
                  await showDialog<bool>(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => AnnouncementEditDialog(
                      id: (item as Announcement).notificationId,
                    ),
                  ) ??
                  false,
              loadData: vm.load,
              availableTags: vm.groups,
              onChangedAvailableTags: vm.groupsChanged,
              enableFastActionSwitch: true,
            );
          },
        );
      },
    );
  }
}
