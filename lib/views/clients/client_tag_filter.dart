import 'package:flutter/material.dart';
import 'package:mml_admin/components/horizontal_spacer.dart';
import 'package:mml_admin/components/list_subfilter_view.dart';
import 'package:mml_admin/models/default_subfilter.dart';

/// Tag filters for the records view.
class ClientTagFilter extends ListSubfilterView {
  final int clients;

  /// Initializes the [ClientTagFilter].
  ClientTagFilter({
    Key? key,
    required this.clients,
  }) : super(key: key, filter: DefaultSubFilter());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _createTagFilter(
          '$clients',
          Icons.phone_android_rounded,
        ),
        horizontalSpacer,
      ],
    );
  }

  /// Creates a single tag filter for given [identifier].
  ///
  /// [icon] can be set.
  Widget _createTagFilter(
    String label,
    IconData icon,
  ) {
    return Chip(
      label: Text(label),
      avatar: Icon(
        icon,
      ),
    );
  }
}
