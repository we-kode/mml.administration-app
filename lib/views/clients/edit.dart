import 'package:flutter/material.dart';
import 'package:mml_admin/components/chip_choices.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/view_models/clients/edit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

/// Edit screen of the client of the music lib.
class ClientEditDialog extends StatelessWidget {
  /// Id of the client to be edited.
  final String? clientId;

  /// Initializes the instance.
  const ClientEditDialog({Key? key, required this.clientId}) : super(key: key);

  /// Builds the clients editing screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClientsEditViewModel>(
      create: (context) => ClientsEditViewModel(),
      builder: (context, _) {
        var vm = Provider.of<ClientsEditViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(locales.editClient),
          content: FutureBuilder(
            future: vm.init(context, clientId),
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
  Widget _createEditForm(BuildContext context, ClientsEditViewModel vm) {
    return Form(
      key: vm.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: vm.client.displayName,
            decoration: InputDecoration(
              labelText: vm.locales.displayName,
              errorMaxLines: 5,
            ),
            onSaved: (String? displayName) {
              vm.clearBackendErrors(vm.displayNameField);
              vm.client.displayName = displayName!;
            },
            onChanged: (String? displayName) {
              vm.clearBackendErrors(vm.displayNameField);
              vm.client.displayName = displayName;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: vm.validateDisplayName,
          ),
          verticalSpacer,
          TextFormField(
            initialValue: vm.client.deviceIdentifier,
            decoration: InputDecoration(
              labelText: vm.locales.deviceName,
              errorMaxLines: 5,
            ),
            onSaved: (String? deviceIdentifier) {
              vm.clearBackendErrors(vm.deviceNameField);
              vm.client.deviceIdentifier = deviceIdentifier!;
            },
            onChanged: (String? deviceIdentifier) {
              vm.clearBackendErrors(vm.deviceNameField);
              vm.client.deviceIdentifier = deviceIdentifier;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: vm.validateDeviceIdentifier,
          ),
          verticalSpacer,
          Text(
            vm.locales.groups,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          verticalSpacer,
          ChipChoices(
            loadData: vm.getGroups,
            initialSelectedItems: vm.client.groups,
            onSelectionChanged: (selecteItems) =>
                vm.client.groups = selecteItems
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
  List<Widget> _createActions(BuildContext context, ClientsEditViewModel vm) {
    var locales = AppLocalizations.of(context)!;

    return [
      Consumer<ClientsEditViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.clientLoadedSuccessfully
                ? () => Navigator.pop(context, false)
                : null,
            child: Text(locales.cancel),
          );
        },
      ),
      Consumer<ClientsEditViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.clientLoadedSuccessfully ? vm.saveClient : null,
            child: Text(locales.save),
          );
        },
      ),
    ];
  }
}
