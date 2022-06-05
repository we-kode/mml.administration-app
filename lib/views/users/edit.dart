import 'package:flutter/material.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/view_models/users/edit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class UsersEditDialog extends StatelessWidget {
  final int? userId;

  const UsersEditDialog({
    Key? key,
    required this.userId,
  }) : super(key: key);

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
                return const Center(child: CircularProgressIndicator());
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

  Widget _createEditForm(BuildContext context, UsersEditDialogViewModel vm) {
    return Form(
      key: vm.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: vm.user.name,
            decoration: InputDecoration(
              labelText: vm.locales.username,
              errorMaxLines: 5,
            ),
            onSaved: (String? name) {
              vm.clearBackendErrors('Name');
              vm.user.name = name!;
            },
            onChanged: (String? password) {
              vm.clearBackendErrors('Name');
              vm.user.password = password!;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: vm.validateUsername,
          ),
          verticalSpacer,
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: vm.passwordLabel,
              errorMaxLines: 5,
            ),
            onSaved: (String? password) {
              vm.clearBackendErrors('Password');
              vm.user.password = password!;
            },
            onChanged: (String? password) {
              vm.clearBackendErrors('Password');
              vm.user.password = password!;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: vm.validatePassword,
          ),
        ],
      ),
    );
  }

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
