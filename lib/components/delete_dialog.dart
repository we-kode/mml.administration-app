import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

showDeleteDialog(BuildContext context) async{
  var localization = AppLocalizations.of(context)!;
  var shouldDelete = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(localization.remove),
      content: Text(localization.areYouSure),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(localization.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(localization.ok),
        ),
      ],
    ),
  );

  return shouldDelete;
}
