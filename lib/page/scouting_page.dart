import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/scouting_page/form_input.dart';
import 'package:scouting_app/page/scouting_page/form_section.dart';
import 'package:scouting_app/provider/form_data_provider.dart';

class ScoutingPage extends ConsumerStatefulWidget {
  const ScoutingPage({super.key});

  @override
  ConsumerState<ScoutingPage> createState() => ScoutingPageState();
}

class ScoutingPageState extends ConsumerState<ScoutingPage> {
  late FormSection matchInfoSection;
  late List<FormSection> sections;
  final _formKey = GlobalKey<FormState>();

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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        onPressed: () async {
                          if (!await showConfirmationDialog(
                            context,
                            ConfirmationInfo(
                              title: "Submit Form",
                              content:
                                  "Are you sure you want to submit the form?",
                            ),
                          )) {
                            return;
                          } // Validate and submit the form
                          if ((_formKey.currentState as FormState).validate()) {
                            // Handle form submission
                            ref
                                .read(currentFormDataProvider.notifier)
                                .setValue("gameFormatName", kGameFormat.name);
                            var formData = ref.read(currentFormDataProvider);
                            var matchData = formData.toMatchData();

                            ref
                                .read(currentFormDataProvider.notifier)
                                .clear(); // Clear form data after submission
                            // TODO: Handle matchData submission
                          }
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 25),
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
                      onPressed: () async {
                        if (!await showConfirmationDialog(
                          context,
                          ConfirmationInfo(
                            title: "Clear Form",
                            content: "Are you sure you want to clear the form?",
                          ),
                        )) {
                          return;
                        } // Handle form reset
                        (_formKey.currentState as FormState).reset();
                        ref.read(currentFormDataProvider.notifier).clear();
                      },
                      child: const Icon(Icons.delete, size: 25),
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
}
