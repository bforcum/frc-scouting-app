import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/model/settings.dart';
import 'package:scouting_app/page/scouting_page/form_input/dropdown_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/text_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/toggle_input.dart';
import 'package:scouting_app/page/scouting_page/form_section.dart';
import 'package:scouting_app/page/settings_page/dummy_data.dart';
import 'package:scouting_app/page/settings_page/reset_database.dart';
import 'package:scouting_app/provider/settings_provider.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SettingsModel settings = ref.watch(settingsProvider);
    AsyncValue<List<String>> events = ref.watch(resultEventsProvider);
    int eventIndex = -1;
    if (events.hasValue) {
      eventIndex =
          settings.selectedEvent == null
              ? 0
              : events.value!.indexOf(settings.selectedEvent!) + 1;
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          spacing: 20,
          children: [
            FormSection(
              title: "User Info",
              children: [
                TextQuestionInput(
                  question: QuestionText(
                    section: 0,
                    key: "",
                    label: "Scout name",
                    length: 30,
                  ),
                  initialValue: settings.scoutName,
                  onChanged:
                      (text) => ref
                          .read(settingsProvider.notifier)
                          .updateSettings(settings.copyWith(scoutName: text)),
                ),
                TextQuestionInput(
                  question: QuestionText(
                    section: 0,
                    key: "",
                    label: "Event name",
                    length: 5,
                  ),
                  initialValue: settings.eventName,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]")),
                  ],
                  onChanged:
                      (text) => ref
                          .read(settingsProvider.notifier)
                          .updateSettings(
                            settings.copyWith(eventName: text.toUpperCase()),
                          ),
                ),
                DropdownQuestionInput(
                  question: QuestionDropdown(
                    section: 0,
                    key: "",
                    label: "Selected Event",
                    options: ["All Events", ...(events.valueOrNull ?? [])],
                    preset: eventIndex,
                  ),
                  onChanged:
                      (eventNum) => ref
                          .read(settingsProvider.notifier)
                          .updateSettings(
                            settings.copyWith(
                              selectedEvent:
                                  (eventNum ?? 0) == 0
                                      ? null
                                      : events.value![eventNum! - 1],
                            ),
                          ),
                ),
              ],
            ),
            FormSection(
              title: "Visual",
              children: [
                DropdownQuestionInput(
                  question: QuestionDropdown(
                    section: 0,
                    key: "",
                    label: "App theme",
                    options: ["System", "Light", "Dark"],
                  ),
                  initialValue: settings.themeMode.index,
                  onChanged:
                      (themeIndex) => ref
                          .read(settingsProvider.notifier)
                          .updateSettings(
                            settings.copyWith(
                              themeMode: ThemeMode.values[themeIndex ?? 0],
                            ),
                          ),
                ),
              ],
            ),
            FormSection(
              title: "Preferences",
              children: [
                ToggleQuestionInput(
                  question: QuestionToggle(
                    section: 0,
                    key: "",
                    label: "Increment match number",
                  ),
                  value: settings.incrementMatchNumber,
                  onChanged:
                      (val) => ref
                          .read(settingsProvider.notifier)
                          .updateSettings(
                            settings.copyWith(incrementMatchNumber: val),
                          ),
                ),
                // Increment match number toggle
              ],
            ),
            FormSection(
              title: "⚠️ Advanced ⚠️",
              children: [
                GenerateDummyData(),
                ResetDatabase(),
                DropdownQuestionInput(
                  question: QuestionDropdown(
                    section: 0,
                    key: "",
                    label: "Game Format",
                    options: List.generate(
                      GameFormat.values.length,
                      (i) => GameFormat.values[i].name,
                    ),
                  ),
                  initialValue: settings.gameFormat.index,
                  onChanged:
                      (i) => ref
                          .read(settingsProvider.notifier)
                          .updateSettings(
                            settings.copyWith(
                              gameFormat:
                                  GameFormat.values[i ??
                                      settings.gameFormat.index],
                            ),
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum ColorTheme {
  system(label: "System", themeValue: ThemeMode.system),
  light(label: "Light", themeValue: ThemeMode.light),
  dark(label: "Dark", themeValue: ThemeMode.dark);

  final String label;
  final ThemeMode themeValue;

  const ColorTheme({required this.label, required this.themeValue});
}
