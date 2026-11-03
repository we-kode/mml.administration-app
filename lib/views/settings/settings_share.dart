import 'package:flutter/material.dart';
import 'package:mml_admin/components/info_title.dart';
import 'package:mml_admin/components/share_options_fields.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/share_settings.dart';
import 'package:mml_admin/view_models/settings/settings_share.dart';
import 'package:provider/provider.dart';

/// Dialog to edit the settings of share links.
class SettingsShareScreen extends StatelessWidget {
  /// Initializes the instance.
  const SettingsShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsShareViewModel>(
      create: (context) => SettingsShareViewModel(),
      builder: (context, _) {
        var vm = Provider.of<SettingsShareViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;
        var textTheme = Theme.of(context).textTheme;

        return AlertDialog(
          title: Text(locales.shareSettings),
          content: SizedBox(
            width: 440,
            child: FutureBuilder(
              future: vm.init(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [CircularProgressIndicator()],
                  );
                }

                return SingleChildScrollView(
                  child: Consumer<SettingsShareViewModel>(
                    builder: (context, vm, _) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          locales.shareAdminLinks,
                          style: textTheme.titleSmall,
                        ),
                        verticalSpacer,
                        ShareOptionsFields(options: vm.options),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(locales.shareUseAsDefault),
                          value: vm.useDefaults,
                          onChanged: vm.useDefaultsChanged,
                        ),
                        verticalSpacer,
                        Text(
                          locales.shareClientLinks,
                          style: textTheme.titleSmall,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: InfoTitle(
                            title: locales.shareUserSettingsAllowed,
                            info: locales.shareUserSettingsInfo,
                          ),
                          value: vm.serverSettings.userSettingsAllowed,
                          onChanged: vm.userSettingsAllowedChanged,
                        ),
                        if (!vm.serverSettings.userSettingsAllowed)
                          ShareOptionsFields(
                            options: vm.serverSettings.userOptions,
                          ),
                        verticalSpacer,
                        InfoTitle(
                          title: locales.shareSearchLinks,
                          info: locales.shareSearchLinksInfo,
                          style: textTheme.titleSmall,
                        ),
                        DropdownButtonFormField<int>(
                          initialValue:
                              ShareSettings.searchLinkRetentionChoices.contains(
                                vm.serverSettings.searchLinkRetentionDays,
                              )
                              ? vm.serverSettings.searchLinkRetentionDays
                              : ShareSettings.defaultSearchLinkRetentionDays,
                          decoration: InputDecoration(
                            labelText: locales.shareSearchLinkRetention,
                          ),
                          items: [
                            for (var days
                                in ShareSettings.searchLinkRetentionChoices)
                              DropdownMenuItem(
                                value: days,
                                child: Text(locales.durationDays(days)),
                              ),
                          ],
                          onChanged: (days) =>
                              vm.serverSettings.searchLinkRetentionDays =
                                  days ??
                                  vm.serverSettings.searchLinkRetentionDays,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
  }
}
