import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
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
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _scKey;
  late ScrollController _scTable;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _scKey = _controllers.addAndGet();
    _scTable = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _scKey.dispose();
    _scTable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GameFormat format = ref.watch(settingsProvider).gameFormat;
    AsyncValue<List<TeamData>> asyncStats = ref.watch(TeamsListProvider(false));
    if (asyncStats.isLoading) return CircularProgressIndicator();
    if (asyncStats.hasError) {
      return Text("An error occured: ${asyncStats.error}");
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Expanded(
        child: Row(
          children: [
            Column(
              children: [
                DataTable(
                  columns: [DataColumn(label: Text("Teams"))],
                  columnSpacing: 20,
                  headingRowColor: WidgetStatePropertyAll(
                    ColorScheme.of(context).surfaceContainer,
                  ),
                  rows: [],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scKey,
                    child: DataTable(
                      columns: [DataColumn(label: Text("Teams"))],
                      columnSpacing: 20,
                      headingRowHeight: 0,
                      rows:
                          asyncStats.requireValue
                              .map(
                                (data) => DataRow(
                                  cells: [
                                    DataCell(Text(data.teamNumber.toString())),
                                  ],
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    DataTable(
                      headingRowColor: WidgetStatePropertyAll(
                        ColorScheme.of(context).surfaceContainer,
                      ),
                      columnSpacing: 20,
                      columns:
                          format.scoreOptions!
                              .map((title) => DataColumn(label: Text(title)))
                              .toList(),
                      rows: [],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scTable,
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowHeight: 0,
                          columns:
                              format.scoreOptions!
                                  .map(
                                    (title) => DataColumn(label: Text(title)),
                                  )
                                  .toList(),
                          rows:
                              asyncStats.requireValue
                                  .map(
                                    (data) => DataRow(
                                      cells:
                                          data.scores
                                              .map(
                                                (numbers) => DataCell(
                                                  Text(
                                                    numbers.average
                                                        .round()
                                                        .toString(),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
