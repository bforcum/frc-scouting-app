import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/team_data.dart';

class DetailGraphPage extends StatefulWidget {
  final TeamData team;
  const DetailGraphPage({super.key, required this.team});

  @override
  State<DetailGraphPage> createState() => _DetailGraphPageState();
}

class _DetailGraphPageState extends State<DetailGraphPage> {
  int scoreOption = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorScheme.of(context).surfaceContainer,
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              padding: EdgeInsets.all(8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return DropdownMenu(
                    initialSelection: scoreOption,
                    onSelected:
                        (value) => setState(() {
                          if (value != null) scoreOption = value;
                        }),
                    label: Text("Sort by"),
                    width: constraints.maxWidth,
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
                        widget.team.gameFormat.scoreOptions!
                            .mapIndexed(
                              (i, e) => DropdownMenuEntry(value: i, label: e),
                            )
                            .toList(),
                  );
                },
              ),
            ),
            Container(
              height: 300,
              padding: EdgeInsets.all(8),
              child: LineChart(
                LineChartData(
                  minY: 0,
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (int i = 0; i < widget.team.results.length; i++)
                          FlSpot(
                            widget.team.results[i].matchNumber.toDouble(),
                            widget.team.scores[scoreOption][i].toDouble(),
                          ),
                      ],
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
