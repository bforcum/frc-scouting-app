import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/database/database.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/team_data.dart';
import 'package:scouting_app/page/common/filter_chip_dropdown.dart';
import 'package:scouting_app/page/list_page/pick_list_card.dart';
import 'package:scouting_app/provider/settings_provider.dart';
import 'package:scouting_app/provider/teams_provider.dart';

class ListPage extends ConsumerStatefulWidget {
  const ListPage({super.key});

  @override
  ConsumerState<ListPage> createState() => _ListPageState();
}

class _ListPageState extends ConsumerState<ListPage> {
  List<TeamData>? pickList;
  bool editMode = false;
  bool filtersVisible = false;
  List<bool>? filterStates;

  @override
  Widget build(BuildContext context) {
    GameFormat format = ref.watch(settingsProvider).gameFormat;
    String? eventCode = ref.watch(settingsProvider).selectedEvent;
    if (format.analysis == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            "Pick list not supported for this game format",
            style: TextTheme.of(context).titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (eventCode == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            "Please select a specific event in settings",
            style: TextTheme.of(context).titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    AsyncValue<List<TeamData>> teams = ref.watch(TeamsListProvider(eventCode));

    if (pickList == null) {
      if (teams.hasValue) {
        pickList =
            teams.requireValue
                .where((team) => team.pickListPosition != null)
                .sortedBy((team) => team.pickListPosition!)
                .toList();
      } else {
        return Center(child: CircularProgressIndicator());
      }
    }

    if (teams.hasError) {
      return Text("An error occurred: ${teams.error}");
    }

    filterStates ??= List.generate(
      format.criteriaOptions!.length,
      (i) => false,
    );

    List<TeamData> filteredPickList =
        editMode
            ? pickList!
            : pickList!.where((team) {
              for (int i = 0; i < filterStates!.length; i++) {
                if (filterStates![i] && !team.criteria[i]) return false;
              }
              return true;
            }).toList();

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ColorScheme.of(context).surfaceContainerHigh,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(
                        editMode ? ColorScheme.of(context).outline : null,
                      ),
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
                  Spacer(),
                  PopupMenuButton(
                    itemBuilder:
                        (context) => [
                          for (
                            int i = 0;
                            i < format.scoreOptions!.length;
                            i++
                          ) ...[
                            PopupMenuItem<int>(
                              value: i + 1,
                              child: Text(
                                "${format.scoreOptions![i]} Ascending",
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: -i - 1,
                              child: Text(
                                "${format.scoreOptions![i]} Descending",
                              ),
                            ),
                          ],
                        ],
                    tooltip: "Sort list",
                    icon: Icon(Icons.sort),
                    onSelected: (value) {
                      setState(() {
                        pickList!.sortBy(
                          (data) =>
                              data.scores[value.abs() - 1].average * value,
                        );
                      });
                      ref
                          .read(TeamsListProvider(eventCode).notifier)
                          .order(
                            format,
                            eventCode,
                            pickList!.map((e) => e.teamNumber).toList(),
                          );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: editMode ? ColorScheme.of(context).primary : null,
                    ),
                    onPressed: () => setState(() => editMode = !editMode),
                  ),
                ],
              ),
              Visibility(
                visible: filtersVisible,
                child: FilterChipDropdown(
                  enabled: !editMode,
                  labels: format.criteriaOptions!,
                  states: filterStates!,
                  onToggle:
                      (i) =>
                          setState(() => filterStates![i] = !filterStates![i]),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView(
            buildDefaultDragHandles: false,
            padding: EdgeInsets.all(8),

            onReorder: (prev, next) async {
              next -= (next > prev) ? 1 : 0;
              // Swap within ephemeral state
              setState(() {
                final TeamData team = pickList!.removeAt(prev);
                pickList!.insert(next, team);
              });

              await ref
                  .read(TeamsListProvider(eventCode).notifier)
                  .move(
                    Team(
                      teamNumber: pickList![next].teamNumber,
                      eventCode: pickList![next].eventCode,
                      gameFormat: format.id,
                      pickListPosition: next,
                    ),
                  );
            },
            children:
                filteredPickList
                    .mapIndexed(
                      (i, e) => PickListCard(
                        key: ValueKey(e.teamNumber),
                        data: e,
                        listPosition: i,
                        editMode: editMode,
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}
