import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/common/snack_bar_message.dart';
import 'package:scouting_app/page/results_page/form_edit_input.dart';
import 'package:scouting_app/page/scouting_page/form_section.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';
import 'package:statistics/statistics.dart';

class EditResultPage extends ConsumerStatefulWidget {
  final MatchResult matchResult;

  const EditResultPage({super.key, required this.matchResult});

  @override
  ConsumerState<EditResultPage> createState() => _EditResultPageState();
}

class _EditResultPageState extends ConsumerState<EditResultPage> {
  late final List<FormSection> sections;
  late Map<String, dynamic> resultData;
  final _formKey = GlobalKey<FormState>();
  bool complete = false;

  @override
  void initState() {
    super.initState();
    // Make a copy of the data so it can be modified
    resultData = widget.matchResult.data.copy();
    GameFormat game = widget.matchResult.gameFormat;

    final matchInfoSection = FormSection(
      title: "Match Information",
      children: [
        FormEditInput(
          value: widget.matchResult.teamNumber,
          question: QuestionNumber(
            section: 0,
            key: "teamNumber",
            label: "Team number",
            min: 1,
          ),
          onChanged: (val) => resultData["teamNumber"] = val as int,
        ),
        FormEditInput(
          value: widget.matchResult.matchNumber,
          question: QuestionNumber(
            section: 0,
            key: "matchNumber",
            label: "Match number",
          ),
          onChanged: (val) => resultData["matchNumber"] = val as int,
        ),
        FormEditInput(
          value: widget.matchResult.eventCode,
          question: QuestionText(
            section: 0,
            key: "eventCode",
            label: "Event code",
            length: 5,
            requiredField: true,
          ),
          onChanged: (val) => resultData["eventCode"] = val as String,
        ),
        FormEditInput(
          value: widget.matchResult.scoutName,
          question: QuestionText(
            section: 0,
            key: "scoutName",
            label: "Scout name",
            length: 30,
          ),
          onChanged: (val) => resultData["scoutName"] = val as String,
        ),
      ],
    );

    List<List<int>> questionIndices = List.generate(
      game.sections.length,
      (i) => [],
    );
    for (int i = 0; i < game.questions.length; i++) {
      questionIndices[game.questions[i].section].add(i);
    }
    sections = [
      matchInfoSection,
      for (int section = 0; section < game.sections.length; section++)
        FormSection(
          title: game.sections[section],
          children:
              questionIndices[section].map((index) {
                return FormEditInput(
                  question: game.questions[index],
                  value: resultData[game.questions[index].key],
                  onChanged: (value) {
                    setState(() {
                      resultData[game.questions[index].key] = value;
                    });
                  },
                );
              }).toList(),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (complete) {
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorScheme.of(context).inversePrimary,
        title: Text("Edit Match Data"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUnfocus,
            child: Column(
              spacing: 20,
              children: [
                ...sections,
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              ColorScheme.of(context).primaryContainer,
                            ),
                          ),
                          onPressed: complete ? null : _save,
                          child: const Text(
                            "Save",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) {
      showSnackBarMessage("Please fill out all required fields.", context);
      return;
    }
    bool confirmation = await showConfirmationDialog(
      ConfirmationInfo(
        title: "Confirm Edit Result",
        content: "Are you sure you want to update this match result?",
      ),
      context,
    );
    if (!confirmation) {
      return null;
    }

    // Handle form submission
    final bool error1 = await ref
        .read(storedResultsProvider.notifier)
        .deleteByUuid([widget.matchResult.id]);

    MatchResult result = MatchResult.fromMap(resultData);

    final String? error2 = await ref
        .read(storedResultsProvider.notifier)
        .addResult(result);

    ref.invalidate(storedResultsProvider);

    if (!mounted) {
      setState(() => complete = true);
      return;
    }

    if (error2 != null) {
      showSnackBarMessage(error2, context);
    } else if (error1) {
      showSnackBarMessage("Something went wrong", context);
    }

    Navigator.pop(context);
    return;
  }
}
