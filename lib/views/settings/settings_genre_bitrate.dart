import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mml_admin/view_models/settings/settings_genre_bitrate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class SettingsGenreBitrate extends StatelessWidget {
  /// Initializes the instance.
  const SettingsGenreBitrate({Key? key}) : super(key: key);

  /// Builds the clients overview screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsGenreBitrateViewModel>(
      create: (context) => SettingsGenreBitrateViewModel(),
      builder: (context, _) {
        var vm =
            Provider.of<SettingsGenreBitrateViewModel>(context, listen: false);
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
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Consumer<SettingsGenreBitrateViewModel>(
                          builder: (context, vm, child) {
                            return ListView.separated(
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 1,
                                );
                              },
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: SizedBox(
                                    width: 500,
                                    child: TextFormField(
                                      key: GlobalKey(),
                                      decoration: InputDecoration(
                                        labelText: locales.genre,
                                      ),
                                      initialValue:
                                          vm.bitrates[index].name ?? '',
                                      onSaved: (String? name) {
                                        vm.bitrates[index].name = name;
                                      },
                                      onChanged: (String? name) {
                                        vm.bitrates[index].name = name;
                                      },
                                    ),
                                  ),
                                  title: SizedBox(
                                    width: 10,
                                    child: TextFormField(
                                      key: GlobalKey(),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      maxLength: 4,
                                      decoration: InputDecoration(
                                        labelText: locales.compressionRate,
                                      ),
                                      initialValue: vm.bitrates[index].bitrate
                                              ?.toString() ??
                                          '',
                                      onSaved: (String? compressionRate) {
                                        var bitrate = int.tryParse(
                                            (compressionRate ?? '0'));
                                        vm.bitrates[index].bitrate =
                                            (bitrate ?? 0) > 0 ? bitrate : null;
                                      },
                                      onChanged: (String? compressionRate) {
                                        var bitrate = int.tryParse(
                                            (compressionRate ?? '0'));
                                        vm.bitrates[index].bitrate =
                                            (bitrate ?? 0) > 0 ? bitrate : null;
                                      },
                                    ),
                                  ),
                                  trailing: TextButton(
                                    onPressed: () async {
                                      await vm.remove(index);
                                    },
                                    child: const Icon(Icons.delete),
                                  ),
                                );
                              },
                              itemCount: vm.bitrates.length,
                            );
                          },
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
    SettingsGenreBitrateViewModel vm,
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
