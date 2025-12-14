import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/model/settings.dart';
import 'package:scouting_app/page/scouting_page/form_input/dropdown_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/text_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/toggle_input.dart';
import 'package:scouting_app/page/scouting_page/form_section.dart';
import 'package:scouting_app/page/settings_page/dummy_data.dart';
import 'package:scouting_app/provider/settings_provider.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SettingsModel settings = ref.watch(settingsProvider);
    AsyncValue<List<String>> events = ref.watch(resultEventsProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          spacing: 20,
          children: [
            FormSection(
              title: "User Info",
              children: [
                TextInput(
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
                TextInput(
                  question: QuestionText(
                    section: 0,
                    key: "",
                    label: "Event name",
                    length: 12,
                  ),
                  initialValue: settings.eventName,
                  onChanged:
                      (text) => ref
                          .read(settingsProvider.notifier)
                          .updateSettings(settings.copyWith(eventName: text)),
                ),
                DropdownInput(
                  question: QuestionDropdown(
                    section: 0,
                    key: "",
                    label: "Selected Event",
                    options: ["All Events", ...(events.valueOrNull ?? [])],
                  ),
                  onChanged:
                      (eventNum) => ref
                          .read(settingsProvider.notifier)
                          .updateSettings(
                            settings.copyWith(
                              selectedEvent:
                                  (eventNum ?? 0) == 0
                                      ? "All Events"
                                      : events.value![eventNum!],
                            ),
                          ),
                ),
              ],
            ),
            FormSection(
              title: "Visual",
              children: [
                DropdownInput(
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
                ToggleInput(
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
            FormSection(title: "Advanced", children: [GenerateDummyData()]),
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
