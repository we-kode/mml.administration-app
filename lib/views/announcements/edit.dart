import 'package:material_ui/material_ui.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/components/async_select_list_dialog.dart';
import 'package:mml_admin/components/chip_choices.dart';
import 'package:mml_admin/components/date_time_field.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/announcement_severity.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/view_models/announcements/edit.dart';
import 'package:provider/provider.dart';

/// Dialog to create or edit an announcement shown to the clients.
class AnnouncementEditDialog extends StatelessWidget {
  /// Id of the announcement to edit or null to create a new one.
  final String? id;

  /// Initializes the dialog.
  const AnnouncementEditDialog({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnnouncementEditViewModel>(
      create: (context) => AnnouncementEditViewModel(),
      builder: (context, _) {
        var vm = Provider.of<AnnouncementEditViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          scrollable: true,
          title: Text(
            id != null ? locales.editAnnouncement : locales.createAnnouncement,
          ),
          content: FutureBuilder(
            future: vm.init(context, id),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [CircularProgressIndicator()],
                );
              }

              return snapshot.data!
                  ? SizedBox(width: 600, child: _createEditForm(context, vm))
                  : Container();
            },
          ),
          actions: [
            Consumer<AnnouncementEditViewModel>(
              builder: (context, value, _) => TextButton(
                onPressed: value.loadedSuccessfully
                    ? () => Navigator.pop(context, false)
                    : null,
                child: Text(locales.cancel),
              ),
            ),
            Consumer<AnnouncementEditViewModel>(
              builder: (context, value, _) => TextButton(
                onPressed: value.loadedSuccessfully ? vm.save : null,
                child: Text(locales.save),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _createEditForm(BuildContext context, AnnouncementEditViewModel vm) {
    var announcement = vm.announcement;
    return Form(
      key: vm.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: announcement.title,
            maxLength: 200,
            decoration: InputDecoration(labelText: vm.locales.title),
            onSaved: (value) => announcement.title = value?.trim(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: vm.validateTitle,
          ),
          TextFormField(
            initialValue: announcement.message,
            minLines: 3,
            maxLines: null,
            decoration: InputDecoration(labelText: vm.locales.message),
            onSaved: (value) => announcement.message = value?.trim(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: vm.validateMessage,
          ),
          Consumer<AnnouncementEditViewModel>(
            builder: (context, vm, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: vm.announcement.severity,
                  decoration: InputDecoration(labelText: vm.locales.severity),
                  items: [
                    for (var severity in AnnouncementSeverity.values)
                      DropdownMenuItem(
                        value: severity,
                        child: Row(
                          children: [
                            Icon(AnnouncementSeverity.icon(severity)),
                            const SizedBox(width: 8),
                            Text(
                              AnnouncementSeverity.text(severity, vm.locales),
                            ),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (value) => vm.setSeverity(value!),
                ),
                verticalSpacer,
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(vm.locales.limitPeriod),
                  subtitle: Text(
                    vm.hasPeriod
                        ? vm.locales.limitPeriodInfo
                        : vm.locales.validUntilDeleted,
                  ),
                  value: vm.hasPeriod,
                  onChanged: vm.setHasPeriod,
                ),
                if (vm.hasPeriod) ...[
                  DateTimeField(
                    label: vm.locales.validFrom,
                    value: vm.announcement.validFrom,
                    onChanged: vm.setValidFrom,
                  ),
                  DateTimeField(
                    label: vm.locales.validTo,
                    value: vm.announcement.validTo,
                    onChanged: vm.setValidTo,
                  ),
                  if (vm.validatePeriod() != null)
                    Text(
                      vm.validatePeriod()!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ],
            ),
          ),
          verticalSpacer,
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Symbols.info),
            title: Text(vm.locales.announcementTargetInfo),
          ),
          Text(vm.locales.groups, style: Theme.of(context).textTheme.bodySmall),
          ChipChoices(
            loadData: vm.getGroups,
            initialSelectedItems: announcement.groups,
            onSelectionChanged: (items) =>
                announcement.groups = items.map((e) => e as Group).toList(),
          ),
          verticalSpacer,
          Text(
            vm.locales.devices,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Consumer<AnnouncementEditViewModel>(
            builder: (context, vm, _) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Symbols.phone_android),
              title: Text(
                vm.selectedClientNames ?? vm.locales.noDevicesSelected,
              ),
              trailing: const Icon(Symbols.edit),
              onTap: () async {
                var selected = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AsyncSelectListDialog(
                    loadData: vm.loadClients,
                    initialSelected: vm.announcement.clientIds,
                  ),
                );
                if (selected != null) {
                  vm.setClients(selected);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
