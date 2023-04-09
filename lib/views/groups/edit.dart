import 'package:flutter/material.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/view_models/groups/edit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

/// View of the create/edit dialog for groups.
class GroupEditDialog extends StatelessWidget {
  /// Id of the group to edit or null if a new group should be created.
  final String? groupId;

  /// Initializes the view for the group create/edit dialog.
  const GroupEditDialog({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  /// Builds the group create/edit dialog.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupEditDialogViewModel>(
      create: (context) => GroupEditDialogViewModel(),
      builder: (context, _) {
        var vm = Provider.of<GroupEditDialogViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(
            groupId != null ? locales.editGroup : locales.createGroup,
          ),
          content: FutureBuilder(
            future: vm.init(context, groupId),
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
  Widget _createEditForm(BuildContext context, GroupEditDialogViewModel vm) {
    return Form(
      key: vm.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: vm.group.name,
            decoration: InputDecoration(
              labelText: vm.locales.groupName,
              errorMaxLines: 5,
            ),
            onSaved: (String? name) {
              vm.clearBackendErrors(vm.nameField);
              vm.group.name = name;
            },
            onChanged: (String? name) {
              vm.clearBackendErrors(vm.nameField);
              vm.group.name = name;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: vm.validateGroupName,
          ),
          verticalSpacer,
          FormField(
            initialValue: vm.group.isDefault,
            builder: (FormFieldState<bool> state) {
              return InputDecorator(
                decoration: InputDecoration(
                  errorText: state.errorText,
                  errorMaxLines: 5,
                ),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    vm.locales.groupIsDefault,
                    style: state.isValid
                        ? null
                        : TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                  ),
                  subtitle: Text(
                    vm.locales.groupIsDefaultHint,
                    style: state.isValid
                        ? null
                        : TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                  ),
                  value: state.value ?? false,
                  onChanged: (bool? isDefault) {
                    state.didChange(isDefault);
                    vm.clearBackendErrors(vm.isDefaultField);
                    vm.group.isDefault = isDefault ?? false;
                  },
                ),
              );
            },
            onSaved: (bool? isDefault) {
              vm.clearBackendErrors(vm.isDefaultField);
              vm.group.isDefault = isDefault ?? false;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: vm.validateIsDefault,
          )
        ],
      ),
    );
  }

  /// Creates a list of action widgets that should be shown at the bottom of the
  /// edit dialog.
  List<Widget> _createActions(
    BuildContext context,
    GroupEditDialogViewModel vm,
  ) {
    var locales = AppLocalizations.of(context)!;

    return [
      Consumer<GroupEditDialogViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.groupLoadedSuccessfully
                ? () => Navigator.pop(context, false)
                : null,
            child: Text(locales.cancel),
          );
        },
      ),
      Consumer<GroupEditDialogViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.groupLoadedSuccessfully ? vm.saveGroup : null,
            child: Text(locales.save),
          );
        },
      ),
    ];
  }
}
