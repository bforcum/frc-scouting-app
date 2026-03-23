import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:scouting_app/database/database.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/team_data.dart';
import 'package:scouting_app/page/analysis_page/analysis_details.dart';
import 'package:scouting_app/provider/settings_provider.dart';
import 'package:scouting_app/provider/teams_provider.dart';

class AnalysisTable extends ConsumerStatefulWidget {
  final String teamSearch;
  final bool pickListOnly;
  final List<bool> filters;
  const AnalysisTable({
    super.key,
    required this.teamSearch,
    required this.filters,
    this.pickListOnly = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalysisTableState();
}

class _AnalysisTableState extends ConsumerState<AnalysisTable> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _scKey;
  late ScrollController _scTable;
  int? sortBy;
  bool ascending = true;
  AsyncValue<List<TeamData>> teamData = AsyncValue.loading();
  List<int> teams = [];

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
    final GameFormat format = ref.watch(settingsProvider).gameFormat;
    final AsyncValue<List<TeamData>> newTeamData = ref.watch(teamsListProvider);
    if (!newTeamData.isLoading) {
      teamData = newTeamData;
    }

    if (teamData.isLoading) {
      return Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: CircularProgressIndicator(),
      );
    }
    if (teamData.hasError) {
      return Text("An error occured: ${teamData.error}");
    }
    teamData = AsyncData(
      teamData.requireValue
          .where((team) {
            if (!team.teamNumber.toString().startsWith(widget.teamSearch)) {
              return false;
            }
            for (int i = 0; i < widget.filters.length; i++) {
              if (widget.filters[i] && !team.criteria[i]) return false;
            }
            if (widget.pickListOnly && team.pickListPosition == null) {
              return false;
            }
            return true;
          })
          .sorted(TeamData.sort(sortBy, ascending)),
    );

    teams = teamData.requireValue.map((e) => e.teamNumber).toList();
    final TextStyle headerStyle = TextTheme.of(
      context,
    ).bodyMedium!.copyWith(fontWeight: FontWeight.w900);
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Expanded(
        child: Row(
          children: [
            Column(
              children: [
                DataTable(
                  horizontalMargin: 10,
                  sortAscending: ascending,
                  sortColumnIndex: sortBy == null ? 0 : null,
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(
                      label: Expanded(
                        child: Row(
                          children: [
                            SizedBox(width: 35),
                            Text("Team", style: headerStyle),
                          ],
                        ),
                      ),
                      headingRowAlignment: MainAxisAlignment.spaceBetween,
                      onSort:
                          (a, b) => setState(() {
                            if (sortBy == null) {
                              ascending = !ascending;
                            } else {
                              sortBy = null;
                              ascending = true;
                            }
                          }),
                    ),
                  ],
                  columnSpacing: 0,
                  headingRowColor: WidgetStatePropertyAll(
                    ColorScheme.of(context).surfaceContainer,
                  ),
                  rows: [],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scKey,
                    child: DataTable(
                      horizontalMargin: 10,
                      showCheckboxColumn: false,
                      dataRowColor: WidgetStatePropertyAll(
                        ColorScheme.of(context).surfaceContainer,
                      ),
                      columns: [
                        DataColumn(
                          label: Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: 35),
                                Text("Team", style: headerStyle),
                              ],
                            ),
                          ),
                          headingRowAlignment: MainAxisAlignment.spaceBetween,
                          onSort:
                              (a, b) => setState(() {
                                if (sortBy == null) {
                                  ascending = !ascending;
                                } else {
                                  sortBy = null;
                                  ascending = true;
                                }
                              }),
                        ),
                      ],
                      columnSpacing: 0,
                      headingRowHeight: 0,
                      rows:
                          teamData.requireValue
                              .map(
                                (team) => DataRow(
                                  cells: [
                                    DataCell(
                                      onTap:
                                          () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      AnalysisDetailsPage(
                                                        data: team,
                                                      ),
                                            ),
                                          ),
                                      Container(
                                        margin: EdgeInsets.all(4),
                                        alignment: AlignmentGeometry.center,
                                        decoration: BoxDecoration(
                                          color:
                                              ColorScheme.of(
                                                context,
                                              ).surfaceContainer,
                                        ),
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value:
                                                  team.pickListPosition != null,
                                              onChanged:
                                                  (value) => _setPickListState(
                                                    team.teamNumber,
                                                    format,
                                                    value,
                                                  ),
                                            ),
                                            Text(team.teamNumber.toString()),
                                          ],
                                        ),
                                      ),
                                    ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DataTable(
                      sortAscending: ascending,
                      sortColumnIndex: sortBy,
                      headingRowColor: WidgetStatePropertyAll(
                        ColorScheme.of(context).surfaceContainer,
                      ),
                      columnSpacing: 20,
                      columns:
                          format.scoreOptions!
                              .map(
                                (title) => DataColumn(
                                  label: Expanded(
                                    child: Text(title, style: headerStyle),
                                  ),
                                  headingRowAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  onSort:
                                      (columnIndex, b) => setState(() {
                                        if (sortBy == columnIndex) {
                                          ascending = !ascending;
                                        } else {
                                          sortBy = columnIndex;
                                          ascending = false;
                                        }
                                      }),
                                ),
                              )
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
                                    (title) => DataColumn(
                                      label: Expanded(
                                        child: Text(title, style: headerStyle),
                                      ),
                                      headingRowAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      onSort:
                                          (columnIndex, b) => setState(() {
                                            if (sortBy == columnIndex) {
                                              ascending = !ascending;
                                            } else {
                                              sortBy = columnIndex;
                                              ascending = false;
                                            }
                                          }),
                                    ),
                                  )
                                  .toList(),
                          rows:
                              teamData.requireValue
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

  Future _setPickListState(
    int teamNumber,
    GameFormat format,
    bool? newValue,
  ) async {
    if (newValue ?? false) {
      ref.read(teamsListProvider.notifier).addToList(teamNumber, format);
    } else {
      ref
          .read(teamsListProvider.notifier)
          .move(
            Team(
              teamNumber: teamNumber,
              gameFormatName: format.name,
              pickListPosition: null,
            ),
          );
    }
  }
}
