import 'package:flutter/material.dart';
import 'package:scouting_app/page/form_page/custom_fields.dart';
import 'package:scouting_app/page/form_page/form_section.dart';

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
              CustomField.number(label: "Match number", hintText: "0"),
              CustomField.number(label: "Team number", hintText: "0000"),
            ],
          ),
          FormSection(
            title: "Tele-Operated",
            children: [
              CustomField.counter(label: "L4 Coral", min: 0, max: 12),
              CustomField.counter(label: "L3 Coral", min: 0, max: 12),
              CustomField.counter(label: "L2 Coral", min: 0, max: 12),
              CustomField.counter(label: "L1 Coral", min: 0, max: 12),
            ],
          ),
        ],
      ),
    );
  }
}
