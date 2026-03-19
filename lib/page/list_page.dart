import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/database/database.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/team_data.dart';
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

  @override
  Widget build(BuildContext context) {
    GameFormat format = ref.watch(settingsProvider).gameFormat;
    if (format.analysis == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            "Pick list not supported for this game format",
            style: TextTheme.of(context).titleMedium,
          ),
        ),
      );
    }
    final AsyncValue<List<TeamData>> teamData = ref.watch(teamsListProvider);

    if (teamData.isLoading && pickList == null) {
      return CircularProgressIndicator();
    }
    if (teamData.hasError) {
      return Text("An error occured: ${teamData.error}");
    }
    if (teamData.hasValue) {
      pickList =
          teamData.requireValue
              .where((data) => data.pickListPosition != null)
              .toList();
    }
    pickList!.sortBy((e) => e.pickListPosition!);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorScheme.of(context).surfaceContainerHigh,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton(
                itemBuilder:
                    (context) => [
                      for (int i = 0; i < format.scoreOptions!.length; i++) ...[
                        PopupMenuItem<int>(
                          value: i + 1,
                          child: Text("${format.scoreOptions![i]} Ascending"),
                        ),
                        PopupMenuItem<int>(
                          value: -i - 1,
                          child: Text("${format.scoreOptions![i]} Descending"),
                        ),
                      ],
                    ],
                tooltip: "Sort list",
                icon: Icon(Icons.sort),
                onSelected: (value) {
                  setState(() {
                    pickList!.sortBy(
                      (data) => data.scores[value.abs() - 1].average * value,
                    );
                  });
                  ref
                      .read(teamsListProvider.notifier)
                      .order(
                        format,
                        pickList!.map((e) => e.teamNumber).toList(),
                      );
                },
              ),
              IconButton(icon: Icon(Icons.edit), onPressed: () {}),
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView(
            buildDefaultDragHandles: false,
            padding: EdgeInsets.all(4),

            onReorder: (prev, next) {
              next -= (next > prev) ? 1 : 0;
              // Swap within ephemeral state
              final TeamData team = pickList!.removeAt(prev);
              pickList!.insert(next, team);

              ref
                  .read(teamsListProvider.notifier)
                  .move(
                    Team(
                      teamNumber: pickList![prev].teamNumber,
                      gameFormatName: format.name,
                      pickListPosition: next,
                    ),
                  );
            },
            children:
                pickList!
                    .mapIndexed(
                      (i, e) => PickListCard(
                        key: ValueKey(e.teamNumber),
                        data: e,
                        listPosition: i,
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}
