import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/view_models/livestreams/edit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class LivestreamEditDialog extends StatelessWidget {
  /// Id of the livestream to edit or null if a new livestream should be created.
  final String? id;

  /// Initializes the view for the livestream create/edit dialog.
  const LivestreamEditDialog({
    Key? key,
    required this.id,
  }) : super(key: key);

  /// Builds the livestream create/edit dialog.
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
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
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
            initialValue: vm.stream.displayName,
            decoration: InputDecoration(
              labelText: vm.locales.displayName,
              errorMaxLines: 5,
            ),
            onSaved: (String? name) {
              vm.clearBackendErrors(vm.nameField);
              vm.stream.displayName = name;
            },
            onChanged: (String? name) {
              vm.clearBackendErrors(vm.nameField);
              vm.stream.displayName = name;
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
          DropdownSearch<Group>.multiSelection(
            selectedItems: vm.stream.groups,
            asyncItems: vm.getGroups,
            itemAsString: (Group group) => group.getDisplayDescription(),
            popupProps: const PopupPropsMultiSelection.menu(
              showSearchBox: true,
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: vm.locales.groups,
                errorMaxLines: 5,
              ),
            ),
            onSaved: (List<Group>? groups) {
              vm.clearBackendErrors(vm.groupsField);
              vm.stream.groups = groups!;
            },
            onChanged: (List<Group> groups) {
              vm.clearBackendErrors(vm.groupsField);
              vm.stream.groups = groups;
            },
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: vm.validateGroups,
          )
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