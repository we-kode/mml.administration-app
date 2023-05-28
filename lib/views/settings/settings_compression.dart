import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mml_admin/view_models/settings/settings_compression.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class SettingsCompressionScreen extends StatelessWidget {
  /// Initializes the instance.
  const SettingsCompressionScreen({Key? key}) : super(key: key);

  /// Builds the clients overview screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsCompressionViewModel>(
      create: (context) => SettingsCompressionViewModel(),
      builder: (context, _) {
        var vm =
            Provider.of<SettingsCompressionViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(locales.editBitrates),
          content: FutureBuilder(
            future: vm.init(context),
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
                  ? Form(
                      key: vm.uploadSettingsKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            decoration: InputDecoration(
                              labelText:
                                  '${vm.locales.defaults} ${vm.locales.compressionRate}',
                              hintText: vm.locales.compressionInfo,
                            ),
                            initialValue:
                                vm.settings.compressionRate?.toString() ?? '',
                            onSaved: (String? compressionRate) {
                              vm.clearBackendErrors(
                                vm.compressionField,
                              );
                              vm.settings.compressionRate = int.tryParse(
                                (compressionRate ?? '0'),
                              );
                            },
                            onChanged: (String? compressionRate) {
                              vm.clearBackendErrors(
                                vm.compressionField,
                              );
                              vm.settings.compressionRate = int.tryParse(
                                (compressionRate ?? '0'),
                              );
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: vm.validateCompressionRate,
                          ),
                        ],
                      ),
                    )
                  : Container();
            },
          ),
          actions: _createActions(context, vm),
        );
      },
    );
  }

  /// Creates a list of action widgets that should be shown at the bottom of the
  /// edit dialog.
  List<Widget> _createActions(
    BuildContext context,
    SettingsCompressionViewModel vm,
  ) {
    var locales = AppLocalizations.of(context)!;

    return [
      TextButton(
        onPressed: vm.abort,
        child: Text(locales.cancel),
      ),
      TextButton(
        onPressed: vm.save,
        child: Text(locales.save),
      ),
    ];
  }
}
