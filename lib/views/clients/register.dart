import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/clients/register.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class ClientRegisterDialog extends StatelessWidget {
  /// Initializes the instance.
  const ClientRegisterDialog({Key? key}) : super(key: key);

  /// Builds the clients editing screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClientsRegisterViewModel>(
      create: (context) => ClientsRegisterViewModel(),
      builder: (context, _) {
        var vm = Provider.of<ClientsRegisterViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(locales.registerClient),
          content: FutureBuilder(
            future: vm.init(context),
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
                  ? _createRegisterForm(context, vm)
                  : Container();
            },
          ),
          actions: _createActions(context, vm),
        );
      },
    );
  }

  Widget _createRegisterForm(
      BuildContext context, ClientsRegisterViewModel vm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Consumer<ClientsRegisterViewModel>(
          builder: (context, value, child) {
            return !value.isClientConfirmed
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      BarcodeWidget(
                        barcode: Barcode.qrCode(),
                        color: Theme.of(context).colorScheme.primary,
                        height: 256,
                        width: 256,
                        data:
                            '{"token": "token", "url" : "url", "appKey" : "appKey"}',
                        errorBuilder: (context, error) => Center(
                          child: Text(error),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                        ),
                        margin: const EdgeInsets.all(100.0),
                        width: 50,
                        height: 50,
                        child: Image.asset(
                          'assets/images/logo.png',
                          scale: 20,
                        ),
                      ),
                    ],
                  )
                : Form(
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
                            vm.client.displayName = displayName!;
                          },
                          onChanged: (String? displayName) {
                            vm.client.displayName = displayName;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: vm.validateDisplayName,
                        ),
                      ],
                    ),
                  );
          },
        ),
      ],
    );
  }

  /// Creates a list of action widgets that should be shown at the bottom of the
  /// edit dialog.
  List<Widget> _createActions(
      BuildContext context, ClientsRegisterViewModel vm) {
    var locales = AppLocalizations.of(context)!;

    return [
      Consumer<ClientsRegisterViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(locales.cancel),
          );
        },
      ),
      Consumer<ClientsRegisterViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.isClientConfirmed ? vm.registerClient : null,
            child: Text(locales.save),
          );
        },
      ),
    ];
  }
}
