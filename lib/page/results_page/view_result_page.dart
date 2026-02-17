import 'package:flutter/material.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/results_page/result_field.dart';
import 'package:scouting_app/page/scouting_page/form_section.dart';

class ViewResultPage extends StatefulWidget {
  final MatchResult matchResult;

  const ViewResultPage({super.key, required this.matchResult});

  @override
  State<ViewResultPage> createState() => _ViewResultPageState();
}

class _ViewResultPageState extends State<ViewResultPage> {
  late final List<FormSection> sections;

  @override
  void initState() {
    super.initState();

    GameFormat game = widget.matchResult.gameFormat;

    List<List<int>> questionIndices = List.generate(
      game.sections.length,
      (i) => [],
    );
    for (int i = 0; i < game.questions.length; i++) {
      questionIndices[game.questions[i].section].add(i);
    }
    sections = List.generate(game.sections.length, (section) {
      return FormSection(
        title: game.sections[section],
        children:
            questionIndices[section].map((index) {
              return MatchResultField(
                question: game.questions[index],
                value: widget.matchResult.data[game.questions[index].key],
              );
            }).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorScheme.of(context).inversePrimary,
        title: Text("View Match Data"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(spacing: 20, children: sections),
        ),
      ),
    );
  }
}
