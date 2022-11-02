import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/view_models/settings.dart';
import 'package:provider/provider.dart';

/// Screen to modify own app settings.
class SettingsScreen extends StatelessWidget {
  /// Initializes the instance.
  const SettingsScreen({Key? key}) : super(key: key);

  /// Builds the settings screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<SettingsViewModel>(
        create: (context) => SettingsViewModel(),
        builder: (context, _) {
          var vm = Provider.of<SettingsViewModel>(context, listen: false);
          return FutureBuilder(
            future: vm.init(context),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Card(
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            trailing: ElevatedButton.icon(
                              onPressed: () {
                                vm.changePassword();
                              },
                              icon: const Icon(Icons.lock),
                              label: Text(vm.locales.changePassword),
                            ),
                            title: Text(
                              '${vm.locales.actualUser}: ${vm.user!.name!}',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Card(
                          child: ListTile(
                            title: Text(
                              vm.locales.uploadSettings,
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Form(
                              key: vm.uploadSettingsKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    decoration: InputDecoration(
                                      labelText: vm.locales.compressionRate,
                                      hintText: vm.locales.compressionInfo,
                                    ),
                                    initialValue: vm.settings.compressionRate
                                            ?.toString() ??
                                        '',
                                    onSaved: (String? compressionRate) {
                                      vm.clearBackendErrors(
                                        vm.compressionField,
                                      );
                                      vm.settings.compressionRate =
                                          int.tryParse(
                                        (compressionRate ?? '0'),
                                      );
                                    },
                                    onChanged: (String? compressionRate) {
                                      vm.clearBackendErrors(
                                        vm.compressionField,
                                      );
                                      vm.settings.compressionRate =
                                          int.tryParse(
                                        (compressionRate ?? '0'),
                                      );
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: vm.validateCompressionRate,
                                  ),
                                  verticalSpacer,
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        vm.saveSettings();
                                      },
                                      child: Text(vm.locales.save),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Card(
                          child: ListTile(
                            title: Text(
                              vm.locales.actualConnectionSettings,
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Stack(
                              alignment: Alignment.center,
                              children: [
                                BarcodeWidget(
                                  padding: const EdgeInsets.all(15),
                                  barcode: Barcode.qrCode(),
                                  color: Theme.of(context).colorScheme.primary,
                                  height: 256,
                                  width: 256,
                                  data: vm.connectionSettings.toString(),
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
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Card(
                          child: ListTile(
                            leading: Text(
                              vm.locales.version,
                            ),
                            title: Text(vm.version),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
