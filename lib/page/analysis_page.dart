import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/page/analysis_page/analysis_table.dart';
import 'package:scouting_app/page/common/filter_chip_dropdown.dart';
import 'package:scouting_app/provider/settings_provider.dart';

class AnalysisPage extends ConsumerStatefulWidget {
  const AnalysisPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends ConsumerState<AnalysisPage> {
  String searchText = "";
  bool pickListOnly = false;
  bool filtersVisible = false;
  List<bool>? filterStates;

  @override
  Widget build(BuildContext context) {
    GameFormat format = ref.watch(settingsProvider).gameFormat;
    if (format.analysis == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            "Analysis not supported for this game format",
            style: TextTheme.of(context).titleMedium,
          ),
        ),
      );
    }
    filterStates ??= List.generate(
      format.criteriaOptions!.length,
      (i) => false,
    );
    return Column(
      children: [
        Container(
          color: ColorScheme.of(context).surfaceContainerHigh,
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
                child: Flex(
                  direction: Axis.horizontal,
                  spacing: 10,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          fillColor:
                              ColorScheme.of(context).surfaceContainerLow,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                          ),
                          hintText: "Team number",
                          hintStyle: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: Theme.of(context).hintColor),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged:
                            (value) => setState(() => searchText = value),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed:
                        () => setState(() {
                          filtersVisible = !filtersVisible;
                        }),
                    label: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Filters", textAlign: TextAlign.center),
                    ),
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        filtersVisible
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                      ),
                    ),
                    iconAlignment: IconAlignment.end,
                  ),
                  TextButton(
                    onPressed:
                        () => setState(() => pickListOnly = !pickListOnly),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Pick List Only",
                        style: TextStyle(
                          color:
                              pickListOnly
                                  ? null
                                  : ColorScheme.of(context).onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: filtersVisible,
                child: FilterChipDropdown(
                  labels:
                      ref.watch(settingsProvider).gameFormat.criteriaOptions!,
                  states: filterStates!,
                  onToggle:
                      (i) =>
                          setState(() => filterStates![i] = !filterStates![i]),
                ),
              ),
            ],
          ),
        ),
        AnalysisTable(
          teamSearch: searchText,
          filters: filterStates!,
          pickListOnly: pickListOnly,
        ),
      ],
    );
  }
}
