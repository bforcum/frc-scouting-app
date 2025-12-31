import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/common/snack_bar_message.dart';
import 'package:scouting_app/page/results_page/form_edit_input.dart';
import 'package:scouting_app/page/scouting_page/form_section.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

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
    resultData = widget.matchResult.data.map((k, v) => MapEntry(k, v));
    GameFormat game = kSupportedGameFormats.firstWhere(
      (gameFormat) => gameFormat.name == widget.matchResult.gameFormatName,
    );

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
              return FormEditInput(
                question: game.questions[index],
                value: resultData[game.questions[index].key],
                onChanged: (value) {
                  resultData[game.questions[index].key] = value;
                  // setState(() {
                  // });
                },
              );
            }).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (complete) {
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Edit Match Data"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                          style: kButtonStyle.copyWith(
                            backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primaryContainer,
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

    MatchResult result = widget.matchResult.copyWith(
      data: resultData,
      timeStamp: DateTime.now(),
    );
    // Handle form submission
    final String? error = await ref
        .read(storedResultsProvider.notifier)
        .updateResult(result);

    ref.invalidate(storedResultsProvider);

    if (!mounted) {
      setState(() => complete = true);
      return;
    }
    if (error != null) {
      showSnackBarMessage(error, context);
    }

    Navigator.pop(context);
    return;
  }
}
