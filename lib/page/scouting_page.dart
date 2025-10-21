import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/form_data.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/common/snack_bar_message.dart';
import 'package:scouting_app/page/scouting_page/form_input.dart';
import 'package:scouting_app/page/scouting_page/form_section.dart';
import 'package:scouting_app/provider/form_field_provider.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

class ScoutingPage extends ConsumerStatefulWidget {
  const ScoutingPage({super.key});

  @override
  ConsumerState<ScoutingPage> createState() => ScoutingPageState();
}

class ScoutingPageState extends ConsumerState<ScoutingPage> {
  late FormSection matchInfoSection;
  late List<FormSection> sections;
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    matchInfoSection = FormSection(
      title: "Match Information",
      children:
          kRequiredQuestions.map((question) {
            return FormInput(question: question);
          }).toList(),
    );

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
              return FormInput(question: kGameFormat.questions[index]);
            }).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Unique key for the form
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
                        style: kButtonStyle.copyWith(
                          backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.primaryContainer,
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
                      style: kButtonStyle.copyWith(
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.errorContainer,
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
        ) ??
        false)) {
      return null;
    } // Validate and submit the form

    // Handle form submission

    final data = <String, dynamic>{};

    data["eventName"] = kEventName;
    data["gameFormatName"] = kGameFormat.name;
    data["timeStamp"] = DateTime.timestamp();

    for (var question in List<Question>.from([
      ...kRequiredQuestions,
      ...kGameFormat.questions,
    ])) {
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
      showSnackBarMessage(error);
      return;
    }

    // Clear form data after submission
    for (var question in List<Question>.from([
      ...kRequiredQuestions,
      ...kGameFormat.questions,
    ])) {
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
        ) ??
        false)) {
      return;
    }

    for (var question in List<Question>.from([
      ...kRequiredQuestions,
      ...kGameFormat.questions,
    ])) {
      ref.read(formFieldNotifierProvider(question.key).notifier).setValue(null);
    }
    ref.read(formResetProvider.notifier).reset();

    _scrollController.jumpTo(0);
  }
}
