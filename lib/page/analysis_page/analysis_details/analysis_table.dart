import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/team_data.dart';
import 'package:scouting_app/provider/settings_provider.dart';
import 'package:scouting_app/provider/teams_provider.dart';

class AnalysisTable extends ConsumerStatefulWidget {
  const AnalysisTable({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalysisTableState();
}

class _AnalysisTableState extends ConsumerState<AnalysisTable> {
  @override
  Widget build(BuildContext context) {
    GameFormat format = ref.watch(settingsProvider).gameFormat;
    AsyncValue<List<TeamData>> asyncStats = ref.watch(TeamsListProvider(false));
    if (asyncStats.isLoading) return CircularProgressIndicator();
    if (asyncStats.hasError) {
      return Text("An error occured: ${asyncStats.error}");
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,

        columns: [
          DataColumn(label: Text("Team")),
          ...format.scoreOptions!.map(
            (title) => DataColumn(label: Text(title)),
          ),
        ],
        rows:
            asyncStats.requireValue
                .map(
                  (data) => DataRow(
                    cells: [
                      DataCell(Text(data.teamNumber.toString())),
                      ...data.scores.map(
                        (numbers) =>
                            DataCell(Text(numbers.average.round().toString())),
                      ),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }
}
