import 'package:flutter/material.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/results_page/result_field.dart';
import 'package:scouting_app/page/scouting_page/form_section.dart';

class ViewResultPage extends StatelessWidget {
  final MatchResult result;

  const ViewResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    GameFormat game = result.gameFormat;

    List<List<int>> questionIndices = List.generate(
      game.sections.length,
      (i) => [],
    );
    for (int i = 0; i < game.questions.length; i++) {
      questionIndices[game.questions[i].section].add(i);
    }
    final matchInformation = FormSection(
      title: "Match Information",
      children: [
        Text(result.timeStamp.toLocal().toString()),
        MatchResultField(label: "Event", value: result.eventName),
        MatchResultField(label: "Scout", value: result.scoutName),
      ],
    );

    final sections = List.generate(game.sections.length, (section) {
      return FormSection(
        title: game.sections[section],
        children:
            questionIndices[section].map((index) {
              return MatchResultField.question(
                question: game.questions[index],
                value: result.data[game.questions[index].key],
              );
            }).toList(),
      );
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorScheme.of(context).inversePrimary,
        title: Text("Team ${result.teamNumber} Match ${result.matchNumber}"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(spacing: 20, children: [matchInformation, ...sections]),
        ),
      ),
    );
  }
}
