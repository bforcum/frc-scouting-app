import 'package:collection/collection.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/team_data.dart';
import 'package:scouting_app/page/analysis_page/analysis_graph_view.dart';
import 'package:scouting_app/page/analysis_page/analysis_list_view.dart';
import 'package:scouting_app/provider/settings_provider.dart';
import 'package:scouting_app/provider/statistics_provider.dart';

class AnalysisPage extends ConsumerStatefulWidget {
  const AnalysisPage({super.key});

  @override
  ConsumerState<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends ConsumerState<AnalysisPage> {
  AsyncValue<List<TeamData>> asyncStats = AsyncValue.loading();
  late final GameFormat gameFormat;
  late int criterion;
  late int mode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    gameFormat = ref.watch(settingsProvider).gameFormat;
    criterion = ref.read(analysisCriterionProvider);
    mode = ref.read(analysisViewProvider);
  }

  @override
  Widget build(BuildContext context) {
    if (gameFormat.scoreOptions == null) {
      return Center(
        child: Text(
          "Analysis not supported for ${gameFormat.name}",
          style: TextTheme.of(context).titleSmall,
          textAlign: TextAlign.center,
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverFloatingHeader(
          child: Container(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomSlidingSegmentedControl<int>(
                  isStretch: true,
                  innerPadding: EdgeInsets.all(4),
                  initialValue: mode,
                  children: {0: Text('List'), 1: Text('Graph')},
                  decoration: BoxDecoration(
                    color: ColorScheme.of(context).surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: ColorScheme.of(
                          context,
                        ).surfaceContainerLowest.withAlpha(80),
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                        offset: Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInToLinear,
                  onValueChanged: (val) {
                    setState(() {
                      mode = val;
                    });
                    ref.read(analysisViewProvider.notifier).set(val);
                  },
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return DropdownMenu<int>(
                      label: Text("Sort by"),
                      width: constraints.maxWidth,
                      initialSelection: criterion,
                      requestFocusOnTap: false,
                      keyboardType: TextInputType.none,
                      enableSearch: false,

                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        labelStyle: Theme.of(context).textTheme.bodyMedium!
                            .copyWith(color: Theme.of(context).hintColor),
                      ),
                      textStyle: Theme.of(context).textTheme.bodySmall,
                      dropdownMenuEntries:
                          gameFormat.scoreOptions!
                              .mapIndexed(
                                (idx, option) => DropdownMenuEntry(
                                  value: idx,
                                  label: option,
                                ),
                              )
                              .toList(),

                      onSelected: (val) {
                        if (val == null) return;
                        setState(() {
                          criterion = val;
                          ref.read(analysisCriterionProvider.notifier).set(val);
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        (mode == 0)
            ? AnalysisListView(key: ValueKey(criterion))
            : AnalysisGraphView(key: ValueKey(criterion)),
      ],
    );
  }
}

// enum SortType { totalPoints, autoPoints, telePoints }
