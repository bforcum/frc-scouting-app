import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/form_data.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/common/snack_bar_message.dart';
import 'package:scouting_app/page/scouting_page/form_input.dart';
import 'package:scouting_app/page/scouting_page/form_section.dart';
import 'package:scouting_app/provider/form_field_provider.dart';
import 'package:scouting_app/provider/settings_provider.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';
import 'package:statistics/statistics.dart';

class ScoutingPage extends ConsumerStatefulWidget {
  const ScoutingPage({super.key});

  @override
  ConsumerState<ScoutingPage> createState() => ScoutingPageState();
}

class ScoutingPageState extends ConsumerState<ScoutingPage> {
  late GameFormat gameFormat;
  late FormSection matchInfoSection;
  late List<FormSection> sections;
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    gameFormat = ref.watch(settingsProvider).gameFormat;
    matchInfoSection = FormSection(
      title: "Match Information",
      children:
          kRequiredQuestions.map((question) {
            return FormInput(question: question);
          }).toList(),
    );

    // Must be generated or the same list reference is duplicated for each section
    List<List<int>> questionIndices = List.generate(
      gameFormat.sections.length,
      (i) => [],
    );
    for (int i = 0; i < gameFormat.questions.length; i++) {
      questionIndices[gameFormat.questions[i].section].add(i);
    }
    sections = List.generate(gameFormat.sections.length, (section) {
      return FormSection(
        title: gameFormat.sections[section],
        children: questionIndices[section].mapToList((index) {
          return FormInput(question: gameFormat.questions[index]);
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          autovalidateMode: AutovalidateMode.onUnfocus,
          key: _formKey,
          child: Column(
            spacing: 20,
            children: [
              matchInfoSection,
              ...sections,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                        onPressed: _submit,
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(12),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          ColorScheme.of(context).errorContainer,
                        ),
                      ),
                      onPressed: _clear,
                      child: const Icon(
                        Icons.delete,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      showSnackBarMessage("Please fill out all required fields.");
      return;
    }

    if (!(await showConfirmationDialog(
      ConfirmationInfo(
        title: "Submit Form",
        content: "Are you sure you want to submit the form?",
      ),
    ))) {
      return null;
    } // Validate and submit the form

    // Handle form submission

    final data = <String, dynamic>{};

    data["gameFormat"] = gameFormat;
    data["timeStamp"] = DateTime.timestamp();

    data["eventName"] = ref.read(settingsProvider).eventName;
    data["scoutName"] = ref.read(settingsProvider).scoutName;

    if (data["eventName"] == null || data["eventName"] == "") {
      showSnackBarMessage("Please set the event name in Settings.");
      return;
    }
    if (data["scoutName"] == null || data["scoutName"] == "") {
      showSnackBarMessage("Please set your scout name in Settings.");
      return;
    }

    for (var question in [...kRequiredQuestions, ...gameFormat.questions]) {
      dynamic value = ref.read(formFieldNotifierProvider(question.key));
      data[question.key] = value;
    }

    MatchResult? matchResult = FormDataModel(data).toMatchResult();

    if (matchResult == null) {
      showSnackBarMessage("Please fill out all fields");
      return;
    }

    final String? error = await ref
        .read(storedResultsProvider.notifier)
        .addResult(matchResult);

    if (error != null) {
      if (error.startsWith("Error: SqliteException(1555)")) {
        showSnackBarMessage(
          "A result for Team ${matchResult.teamNumber} in Match ${matchResult.matchNumber} already exists.",
        );
      } else {
        showSnackBarMessage(error);
      }
      return;
    }
    // Clear form data after submission
    for (var question in List<Question>.from([
      ...kRequiredQuestions,
      ...gameFormat.questions,
    ])) {
      // Auto-increment match number if enabled
      if (question.key == "matchNumber" &&
          ref.read(settingsProvider).incrementMatchNumber) {
        ref
            .read(formFieldNotifierProvider(question.key).notifier)
            .setValue(matchResult.matchNumber + 1);
        continue;
      }
      ref.read(formFieldNotifierProvider(question.key).notifier).setValue(null);
    }
    ref.read(formResetProvider.notifier).reset();

    _scrollController.jumpTo(0);
  }

  void _clear() async {
    if (!(await showConfirmationDialog(
      ConfirmationInfo(
        title: "Clear Form",
        content: "Are you sure you want to clear the form?",
      ),
    ))) {
      return;
    }

    for (var question in List<Question>.from([
      ...kRequiredQuestions,
      ...gameFormat.questions,
    ])) {
      ref.read(formFieldNotifierProvider(question.key).notifier).setValue(null);
    }
    ref.read(formResetProvider.notifier).reset();

    _scrollController.jumpTo(0);
  }
}
