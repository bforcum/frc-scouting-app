import 'package:flutter/material.dart';
import 'package:scouting_app/model/team_data.dart';

class AnalysisDetailsPage extends StatefulWidget {
  final TeamData data;

  const AnalysisDetailsPage({super.key, required this.data});

  @override
  State<AnalysisDetailsPage> createState() => _AnalysisDetailsPageState();
}

class _AnalysisDetailsPageState extends State<AnalysisDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Team ${widget.data.teamNumber}"),
        backgroundColor: ColorScheme.of(context).inversePrimary,
      ),
    );
  }
}
