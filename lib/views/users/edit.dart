import 'package:flutter/material.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/view_models/users/edit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

/// View of the create/edit dialog for users.
class UsersEditDialog extends StatelessWidget {
  /// Id of the user to edit or null if a new user should be created.
  final int? userId;

  /// Initializes the view for the user create/edit dialog.
  const UsersEditDialog({
    Key? key,
    required this.userId,
  }) : super(key: key);

  /// Builds the user create/edit dialog.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsersEditDialogViewModel>(
      create: (context) => UsersEditDialogViewModel(),
      builder: (context, _) {
        var vm = Provider.of<UsersEditDialogViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(
            userId != null ? locales.editUser : locales.createUser,
          ),
          content: FutureBuilder(
            future: vm.init(context, userId),
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
  Widget _createEditForm(BuildContext context, UsersEditDialogViewModel vm) {
    return Form(
      key: vm.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: vm.user.name,
            decoration: InputDecoration(
              labelText: vm.locales.username,
              errorMaxLines: 5,
            ),
            onSaved: (String? name) {
              vm.clearBackendErrors(vm.nameField);
              vm.user.name = name;
            },
            onChanged: (String? name) {
              vm.clearBackendErrors(vm.nameField);
              vm.user.name = name;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: vm.validateUsername,
          ),
          verticalSpacer,
          Consumer<UsersEditDialogViewModel>(
            builder: (context, value, child) {
              return TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: vm.passwordLabel,
                  errorMaxLines: 5,
                ),
                onSaved: (String? password) {
                  vm.clearBackendErrors(vm.passwordField);
                  vm.password = password;
                },
                onChanged: (String? password) {
                  vm.clearBackendErrors(vm.passwordField);
                  vm.password = password;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: vm.validatePassword,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Creates a list of action widgets that should be shown at the bottom of the
  /// edit dialog.
  List<Widget> _createActions(
    BuildContext context,
    UsersEditDialogViewModel vm,
  ) {
    var locales = AppLocalizations.of(context)!;

    return [
      Consumer<UsersEditDialogViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.userLoadedSuccessfully
                ? () => Navigator.pop(context, false)
                : null,
            child: Text(locales.cancel),
          );
        },
      ),
      Consumer<UsersEditDialogViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.userLoadedSuccessfully ? vm.saveUser : null,
            child: Text(locales.save),
          );
        },
      ),
    ];
  }
}
