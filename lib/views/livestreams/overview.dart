import 'package:flutter/cupertino.dart';
import 'package:mml_admin/view_models/livestreams/overview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class LiveStreamsScreen extends StatelessWidget {
  /// Initializes the instance.
  const LiveStreamsScreen({Key? key}) : super(key: key);

  /// Builds the records overview screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LiveStreamsViewModel>(
      create: (context) => LiveStreamsViewModel(),
      builder: (context, _) {
        var vm = Provider.of<LiveStreamsViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return Container();
      },
    );
  }
}
