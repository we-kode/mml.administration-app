import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/settings_genre_bitrate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class SettingsGenreBitrate extends StatelessWidget {
  /// Initializes the instance.
  const SettingsGenreBitrate({Key? key}) : super(key: key);

  /// Builds the clients overview screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsGenreBitrateviewModel>(
      create: (context) => SettingsGenreBitrateviewModel(),
      builder: (context, _) {
        var vm =
            Provider.of<SettingsGenreBitrateviewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(locales.bitrates),
              TextButton(
                onPressed: vm.add,
                child: const Icon(Icons.add),
              ),
            ],
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
                  ? ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: false,
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const Divider(
                              height: 1,
                            );
                          },
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('test'),
                            );
                          },
                          itemCount: 20,
                        ),
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
    SettingsGenreBitrateviewModel vm,
  ) {
    var locales = AppLocalizations.of(context)!;

    return [
      Consumer<SettingsGenreBitrateviewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: vm.abort,
            child: Text(locales.cancel),
          );
        },
      ),
      Consumer<SettingsGenreBitrateviewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: vm.save,
            child: Text(locales.save),
          );
        },
      ),
    ];
  }
}
