import 'package:flutter/material.dart';
import 'package:mml_admin/components/chip_choices.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/view_models/livestreams/edit.dart';
import 'package:provider/provider.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';

class LivestreamEditDialog extends StatelessWidget {
  /// Id of the live stream to edit or null if a new live stream should be created.
  final String? id;

  /// Initializes the view for the live stream create/edit dialog.
  const LivestreamEditDialog({
    super.key,
    required this.id,
  });

  /// Builds the live stream create/edit dialog.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LivestreamEditDialogViewModel>(
      create: (context) => LivestreamEditDialogViewModel(),
      builder: (context, _) {
        var vm = Provider.of<LivestreamEditDialogViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(
            id != null ? locales.editLivestream : locales.createLivestream,
          ),
          content: FutureBuilder(
            future: vm.init(context, id),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                  ],
                );
              }

              return snapshot.data!
                  ? _createEditForm(context, vm)
                  : Container();
            },
          ),
          actions: _createActions(context, vm),
        );
      },
    );
  }

  /// Creates the edit form that should be shown in the dialog.
  Widget _createEditForm(BuildContext context, LivestreamEditDialogViewModel vm) {
    return Form(
      key: vm.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: vm.stream.title,
            decoration: InputDecoration(
              labelText: vm.locales.displayName,
              errorMaxLines: 5,
            ),
            onSaved: (String? name) {
              vm.clearBackendErrors(vm.nameField);
              vm.stream.title = name;
            },
            onChanged: (String? name) {
              vm.clearBackendErrors(vm.nameField);
              vm.stream.title = name;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: vm.validateDisplayName,
          ),
          verticalSpacer,
          TextFormField(
            initialValue: vm.stream.url,
            decoration: InputDecoration(
              labelText: vm.locales.streamUrl,
              hintText: vm.locales.streamUrlHint,
              errorMaxLines: 5,
            ),
            onSaved: (String? url) {
              vm.stream.url = url;
            },
            onChanged: (String? url) {
              vm.stream.url = url;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          verticalSpacer,
          ChipChoices(
            loadData: vm.getGroups,
            initialSelectedItems: vm.stream.groups,
            onSelectionChanged: (selectableItems) =>
                vm.stream.groups = selectableItems
                    .map(
                      (e) => e as Group,
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  /// Creates a list of action widgets that should be shown at the bottom of the
  /// edit dialog.
  List<Widget> _createActions(
    BuildContext context,
    LivestreamEditDialogViewModel vm,
  ) {
    var locales = AppLocalizations.of(context)!;

    return [
      Consumer<LivestreamEditDialogViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.loadedSuccessfully
                ? () => Navigator.pop(context, false)
                : null,
            child: Text(locales.cancel),
          );
        },
      ),
      Consumer<LivestreamEditDialogViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.loadedSuccessfully ? vm.save : null,
            child: Text(locales.save),
          );
        },
      ),
    ];
  }
}
