import 'package:flutter/material.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/page/scouting_page/form_input.dart';
import 'package:scouting_app/page/scouting_page/form_section.dart';

class ScoutingPage extends StatefulWidget {
  const ScoutingPage({super.key});

  @override
  State<ScoutingPage> createState() => ScoutingPageState();
}

class ScoutingPageState extends State<ScoutingPage> {
  late List<FormSection> sections;

  @override
  void initState() {
    super.initState();
    List<List<int>> questionIndices = List.generate(
      kGameFormat.sections.length,
      (i) => [],
    );
    for (int i = 0; i < kGameFormat.questions.length; i++) {
      questionIndices[kGameFormat.questions[i].section].add(i);
    }
    sections = List.generate(kGameFormat.sections.length, (section) {
      return FormSection(
        title: kGameFormat.sections[section],
        children:
            questionIndices[section].map((index) {
              return FormInput.fromQuestion(
                kGameFormat.questions[index],
                onChanged: (value) {}, // TODO: Handle input changes
              );
            }).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 20,
          children: [
            FormSection(
              title: "Match Info",
              children: [
                FormInput.fromQuestion(
                  QuestionNumber(section: 0, label: "Match number", hint: "0"),
                ),
                FormInput.fromQuestion(
                  QuestionNumber(
                    section: 0,
                    label: "Team number",
                    hint: "0000",
                  ),
                ),
              ],
            ),
          ]..addAll(sections),
        ),
      ),
    );
  }
}

          // [
          //   FormSection(
          //     title: "Match Info",
          //     children: [
          //       FormInput.fromQuestion(
          //         QuestionNumber(section: 0, label: "Match number", hint: "0"),
          //       ),
          //       FormInput.fromQuestion(
          //         QuestionNumber(
          //           section: 0,
          //           label: "Team number",
          //           hint: "0000",
          //         ),
          //       ),
          //     ],
          //   ),
          //   FormSection(
          //     title: "Tele-Operated",
          //     children: [
          //       FormInput.fromQuestion(
          //         QuestionCounter(
          //           section: 1,
          //           label: "L4 Coral",
          //           min: 0,
          //           max: 12,
          //         ),
          //       ),
          //       FormInput.fromQuestion(
          //         QuestionCounter(
          //           section: 1,
          //           label: "L3 Coral",
          //           min: 0,
          //           max: 12,
          //         ),
          //       ),
          //       FormInput.fromQuestion(
          //         QuestionCounter(
          //           section: 1,
          //           label: "L2 Coral",
          //           min: 0,
          //           max: 12,
          //         ),
          //       ),
          //       FormInput.fromQuestion(
          //         QuestionCounter(
          //           section: 1,
          //           label: "L1 Coral",
          //           min: 0,
          //           max: 12,
          //         ),
          //       ),
          //       FormInput.fromQuestion(
          //         QuestionToggle(section: 1, label: "Movement"),
          //       ),
          //       FormInput.fromQuestion(
          //         QuestionDropdown(
          //           section: 1,
          //           label: "Robot damage",
          //           options: ["None", "Minor", "Major"],
          //         ),
          //       ),
          //       FormInput.fromQuestion(
          //         QuestionText(
          //           section: 1,
          //           label: "Additional Notes",
          //           hintText: "Enter any additional notes here",
          //           length: 100,
          //         ),
          //       ),
          //     ],
          //   ),
          // ],