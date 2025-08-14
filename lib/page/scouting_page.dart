import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/page/scouting_page/form_input.dart';
import 'package:scouting_app/page/scouting_page/form_section.dart';

class ScoutingPage extends StatefulWidget {
  const ScoutingPage({super.key});

  @override
  State<ScoutingPage> createState() => ScoutingPageState();
}

class ScoutingPageState extends State<ScoutingPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 20,
        children: [
          FormSection(
            title: "Match Info",
            children: [
              CustomField.fromQuestion(
                QuestionNumber(section: 0, label: "Match number", hint: "0"),
              ),
              CustomField.fromQuestion(
                QuestionNumber(section: 0, label: "Team number", hint: "0000"),
              ),
            ],
          ),
          FormSection(
            title: "Tele-Operated",
            children: [
              CustomField.fromQuestion(
                QuestionCounter(section: 1, label: "L4 Coral", min: 0, max: 12),
              ),
              CustomField.fromQuestion(
                QuestionCounter(section: 1, label: "L3 Coral", min: 0, max: 12),
              ),
              CustomField.fromQuestion(
                QuestionCounter(section: 1, label: "L2 Coral", min: 0, max: 12),
              ),
              CustomField.fromQuestion(
                QuestionCounter(section: 1, label: "L1 Coral", min: 0, max: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
