import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/check_animation.dart';
import 'package:mml_admin/components/chip_choices.dart';
import 'package:mml_admin/components/error_animation.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/view_models/clients/register.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class ClientRegisterDialog extends StatelessWidget {
  /// Initializes the instance.
  const ClientRegisterDialog({Key? key}) : super(key: key);

  /// Builds the clients registration screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClientsRegisterViewModel>(
      create: (context) => ClientsRegisterViewModel(),
      builder: (context, _) {
        var vm = Provider.of<ClientsRegisterViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Consumer<ClientsRegisterViewModel>(
            builder: (context, vm, child) {
              return vm.state != RegistrationState.preCheck
                  ? Text(locales.registerClient)
                  : Text(locales.similiarClients);
            },
          ),
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
    BuildContext context,
    ClientsRegisterViewModel vm,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Consumer<ClientsRegisterViewModel>(
          builder: (context, value, child) {
            return value.registration == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(),
                    ],
                  )
                : _actualState(context, value);
          },
        ),
      ],
    );
  }

  Widget _actualState(BuildContext context, ClientsRegisterViewModel vm) {
    switch (vm.state) {
      case RegistrationState.scan:
        return Stack(
          alignment: Alignment.center,
          children: [
            BarcodeWidget(
              barcode: Barcode.qrCode(),
              color: Theme.of(context).colorScheme.primary,
              height: 264,
              width: 264,
              data: vm.registration.toString(),
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
        );
      case RegistrationState.success:
        return Container(
          alignment: Alignment.center,
          height: 264,
          width: 264,
          child: CheckAnimation(
            onStop: () async {
              await vm.stopAnimation();
            },
          ),
        );
      case RegistrationState.preCheck:
        return SizedBox(
          height: 400,
          width: 400,
          child: Consumer<ClientsRegisterViewModel>(
            builder: (context, value, child) {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                  );
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Wrap(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            vm.similiarClients[index]!.getDisplayDescription(),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                        Text(
                          " (${vm.similiarClients[index]!.getDisplayDescriptionSuffix(context)})",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            vm.similiarClients[index]!.getSubtitle(context)!,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        vm.deleteClient(
                          index,
                          context,
                        );
                      },
                      icon: const Icon(Icons.delete),
                      tooltip: AppLocalizations.of(context)!.remove,
                    ),
                  );
                },
                itemCount: vm.similiarClients.length,
              );
            },
          ),
        );
      case RegistrationState.register:
        return Form(
          key: vm.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: vm.client!.displayName,
                decoration: InputDecoration(
                  labelText: vm.locales.displayName,
                  errorMaxLines: 5,
                ),
                onSaved: (String? displayName) {
                  vm.client!.displayName = displayName!;
                },
                onChanged: (String? displayName) {
                  vm.client!.displayName = displayName;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: vm.validateDisplayName,
              ),
              verticalSpacer,
              TextFormField(
                initialValue: vm.client!.deviceIdentifier,
                decoration: InputDecoration(
                  labelText: vm.locales.deviceName,
                  errorMaxLines: 5,
                ),
                onSaved: (String? deviceIdentifier) {
                  vm.client!.deviceIdentifier = deviceIdentifier!;
                },
                onChanged: (String? deviceIdentifier) {
                  vm.client!.deviceIdentifier = deviceIdentifier;
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
                initialSelectedItems: vm.client!.groups,
                onSelectionChanged: (selecteItems) =>
                    vm.client!.groups = selecteItems
                        .map(
                          (e) => e as Group,
                        )
                        .toList(),
              ),
            ],
          ),
        );
      case RegistrationState.error:
        return Container(
          alignment: Alignment.center,
          height: 264,
          width: 264,
          child: ErrorAnimation(
            onStop: () async {
              vm.stopErrorAnimation();
            },
          ),
        );
    }
  }

  /// Creates a list of action widgets that should be shown at the bottom of the
  /// edit dialog.
  List<Widget> _createActions(
    BuildContext context,
    ClientsRegisterViewModel vm,
  ) {
    var locales = AppLocalizations.of(context)!;

    return [
      Consumer<ClientsRegisterViewModel>(
        builder: (context, value, child) {
          return vm.state == RegistrationState.scan
              ? TextButton(
                  onPressed:
                      vm.state == RegistrationState.register ? null : vm.abort,
                  child: Text(locales.cancel),
                )
              : const SizedBox.shrink();
        },
      ),
      Consumer<ClientsRegisterViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: vm.state == RegistrationState.register
                ? vm.saveClient
                : vm.state == RegistrationState.preCheck
                    ? vm.preCheckFinished
                    : null,
            child: Text(locales.save),
          );
        },
      ),
    ];
  }
}
