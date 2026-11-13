import 'package:material_ui/material_ui.dart';
import 'package:mml_admin/components/info_title.dart';
import 'package:mml_admin/components/tag_selection.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/album.dart';
import 'package:mml_admin/models/artist.dart';
import 'package:mml_admin/models/genre.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/view_models/share_rules/edit.dart';
import 'package:provider/provider.dart';

/// Dialog to create or edit a rule, which allows the clients of groups to share
/// records.
class ShareRuleEditDialog extends StatelessWidget {
  /// Id of the rule to edit or null to create a new one.
  final String? id;

  /// Initializes the dialog.
  const ShareRuleEditDialog({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShareRuleEditViewModel>(
      create: (context) => ShareRuleEditViewModel(id),
      builder: (context, _) {
        var vm = Provider.of<ShareRuleEditViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return FutureBuilder(
          future: vm.loaded,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [CircularProgressIndicator()],
                ),
              );
            }

            if (!snapshot.data!) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => Navigator.pop(context, true),
              );
              return const SizedBox.shrink();
            }

            return AlertDialog(
              scrollable: true,
              title: Text(
                id != null ? locales.editShareRule : locales.addShareRule,
              ),
              content: SizedBox(
                width: 560,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(locales.shareRulesInfo),
                    verticalSpacer,
                    TagSelection<Group>(
                      label: locales.groups,
                      values: vm.rule.groups,
                      loadData: vm.loadGroups,
                    ),
                    verticalSpacer,
                    Consumer<ShareRuleEditViewModel>(
                      builder: (context, vm, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: InfoTitle(
                              title: locales.shareAllRecords,
                              info: locales.shareAllRecordsInfo,
                            ),
                            value: vm.rule.allRecords,
                            onChanged: vm.setAllRecords,
                          ),
                          if (!vm.rule.allRecords) ...[
                            verticalSpacer,
                            TagSelection<Genre>(
                              label: locales.genre,
                              values: vm.rule.genres,
                              loadData: vm.loadGenres,
                              helperText: locales.ruleEmptyMatchesAll,
                            ),
                            verticalSpacer,
                            TagSelection<Album>(
                              label: locales.album,
                              values: vm.rule.albums,
                              loadData: vm.loadAlbums,
                              helperText: locales.ruleEmptyMatchesAll,
                            ),
                            verticalSpacer,
                            TagSelection<Artist>(
                              label: locales.artist,
                              values: vm.rule.artists,
                              loadData: vm.loadArtists,
                              helperText: locales.ruleEmptyMatchesAll,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(locales.cancel),
                ),
                TextButton(
                  onPressed: () => vm.save(context),
                  child: Text(locales.save),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
