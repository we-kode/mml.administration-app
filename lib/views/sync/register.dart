import 'package:flutter/material.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/view_models/sync/register.dart';
import 'package:provider/provider.dart';

/// Dialog to request the registration at a partner.
class PeerRegisterDialog extends StatelessWidget {
  /// Initializes the dialog.
  const PeerRegisterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PeerRegisterViewModel>(
      create: (context) => PeerRegisterViewModel(),
      builder: (context, _) {
        var vm = Provider.of<PeerRegisterViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(locales.requestRegistration),
          content: SizedBox(
            width: 500,
            child: Form(
              key: vm.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(locales.requestRegistrationInfo),
                  verticalSpacer,
                  TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: locales.peerUrl,
                      hintText: 'https://',
                      errorMaxLines: 3,
                    ),
                    keyboardType: TextInputType.url,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => vm.validateUrl(value, locales),
                    onSaved: (value) => vm.baseUrl = value ?? '',
                  ),
                  verticalSpacer,
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: locales.invitationCode,
                      hintText: 'XXXXX-XXXXX-XXXXX-XXXXX',
                      errorMaxLines: 3,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => vm.validateCode(value, locales),
                    onSaved: (value) => vm.invitationCode = value ?? '',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(locales.cancel),
            ),
            TextButton(
              onPressed: () => vm.request(context),
              child: Text(locales.requestRegistrationSend),
            ),
          ],
        );
      },
    );
  }
}
