import 'package:flutter/material.dart';
import 'package:scouting_app/model/team_data.dart';
import 'package:scouting_app/page/analysis_page/analysis_details/detail_comments_page.dart';
import 'package:scouting_app/page/analysis_page/analysis_details/detail_graph_page.dart';
import 'package:scouting_app/page/analysis_page/analysis_details/detail_strategy_page.dart';
import 'package:scouting_app/page/common/custom_navigation_bar.dart';

class AnalysisDetailsPage extends StatefulWidget {
  final TeamData data;

  const AnalysisDetailsPage({super.key, required this.data});

  @override
  State<AnalysisDetailsPage> createState() => _AnalysisDetailsPageState();
}

class _AnalysisDetailsPageState extends State<AnalysisDetailsPage> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Team ${widget.data.teamNumber}"),
        backgroundColor: ColorScheme.of(context).inversePrimary,
      ),
      bottomNavigationBar: CustomNavigationBar(
        destinationIcons: [Icons.comment, Icons.show_chart, Icons.analytics],
        destinationLabels: ["Comments", "Graph", "Strategy"],
        selectedIndex: page,
        onDestinationSelected: (index) => setState(() => page = index),
      ),
      body:
          [
            DetailCommentsPage(data: widget.data),
            DetailGraphPage(team: widget.data),
            DetailStrategyPage(team: widget.data),
          ][page],
    );
  }
}
