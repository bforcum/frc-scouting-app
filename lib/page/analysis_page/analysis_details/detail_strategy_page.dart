import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/model/team_data.dart';
import 'package:scouting_app/page/scouting_page/form_section.dart';

class DetailStrategyPage extends StatelessWidget {
  final TeamData team;
  const DetailStrategyPage({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    List<QuestionSelect> selectQuestions =
        team.gameFormat.questions
            .where((q) => q.type == QuestionType.select)
            .map((q) => q as QuestionSelect)
            .toList();
    List<Map<String, dynamic>> data = team.results.map((e) => e.data).toList();
    List<Widget> charts = [];
    for (QuestionSelect question in selectQuestions) {
      List<int> selectResults =
          data.map((e) => e[question.key] as int).toList();
      charts.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(question.label),
            ),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: [
                    for (int i = 0; i < question.options.length; i++)
                      PieChartSectionData(
                        color:
                            HSLColor.fromAHSL(
                              1.0,
                              (-i * 30.0) % 360.0,
                              1.0,
                              0.4,
                            ).toColor(),
                        title: question.options[i],
                        value:
                            selectResults
                                .reduce((a, b) => b == i ? a + 1 : a)
                                .toDouble(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          spacing: 12,
          children: [FormSection(title: "Stats", children: charts)],
        ),
      ),
    );
  }
}
