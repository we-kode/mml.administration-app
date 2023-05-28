import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/settings/settings_connection.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class SettingsConnectionScreen extends StatelessWidget {
  /// Initializes the instance.
  const SettingsConnectionScreen({Key? key}) : super(key: key);

  /// Builds the clients overview screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsConnectionViewModel>(
      create: (context) => SettingsConnectionViewModel(),
      builder: (context, _) {
        var vm =
            Provider.of<SettingsConnectionViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(locales.actualConnectionSettings),
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
                  ? Stack(
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
    SettingsConnectionViewModel vm,
  ) {
    var locales = AppLocalizations.of(context)!;

    return [
      TextButton(
        onPressed: vm.abort,
        child: Text(locales.ok),
      ),
    ];
  }
}
