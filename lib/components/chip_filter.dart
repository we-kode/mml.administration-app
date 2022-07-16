import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/components/horizontal_spacer.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/id3_tag_filter.dart';

typedef FilterChangedFunction = Future<bool> Function(ID3TagFilter filter);

class ChipFilterView extends StatefulWidget {
  final FilterChangedFunction onFilterChanged;

  const ChipFilterView({
    required this.onFilterChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<ChipFilterView> createState() => _ChipFilterViewState();
}

class _ChipFilterViewState extends State<ChipFilterView> {
  final _tagFilter = ID3TagFilter();

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    return Row(
      children: [
        InputChip(
          label: Text(locales.date),
          avatar: const Icon(Icons.calendar_month),
          backgroundColor:
              _tagFilter.startDate != null ? Colors.blueGrey : null,
          onPressed: () => widget.onFilterChanged(_tagFilter),
          onDeleted: _tagFilter.startDate != null
              ? () => {
                    setState(
                      () => {
                        _tagFilter.startDate = null,
                        _tagFilter.endDate = null,
                        widget.onFilterChanged(_tagFilter)
                      },
                    ),
                  }
              : null,
        ),
        horizontalSpacer,
        InputChip(
          label: Text(locales.artist),
          avatar: const Icon(Icons.person),
          backgroundColor: _tagFilter.artists.isNotEmpty ? Colors.teal : null,
          onPressed: () => widget.onFilterChanged(_tagFilter),
          onDeleted: _tagFilter.artists.isNotEmpty
              ? () => {
                    setState(
                      () => {
                        _tagFilter.artists.clear(),
                        widget.onFilterChanged(_tagFilter)
                      },
                    ),
                  }
              : null,
        ),
        horizontalSpacer,
        InputChip(
          label: Text(locales.genre),
          avatar: const Icon(Icons.discount),
          backgroundColor: _tagFilter.genres.isNotEmpty ? Colors.red : null,
          onPressed: () => widget.onFilterChanged(_tagFilter),
          onDeleted: _tagFilter.genres.isNotEmpty
              ? () => {
                    setState(
                      () => {
                        _tagFilter.genres.clear(),
                        widget.onFilterChanged(_tagFilter)
                      },
                    ),
                  }
              : null,
        ),
        horizontalSpacer,
        InputChip(
          label: Text(locales.album),
          avatar: const Icon(Icons.library_music),
          backgroundColor: _tagFilter.albums.isNotEmpty ? Colors.amber : null,
          onPressed: () => {
            setState(
              () => {
                _tagFilter.albums.add('03f6ed65-3ef5-4d3f-ad91-6e1fcecfb15e'),
                widget.onFilterChanged(_tagFilter)
              },
            ),
          },
          onDeleted: _tagFilter.albums.isNotEmpty
              ? () => {
                    setState(
                      () => {
                        _tagFilter.albums.clear(),
                        widget.onFilterChanged(_tagFilter)
                      },
                    ),
                  }
              : null,
        ),
        horizontalSpacer,
      ],
    );
  }
}
