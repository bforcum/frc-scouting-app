import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
sealed class SettingsModel with _$SettingsModel {
  const SettingsModel._();
  const factory SettingsModel({
    @Default("") String scoutName,
    @Default("") String eventName,
    String? selectedEvent,
    @Default(true) bool incrementMatchNumber,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(GameFormat.v2026) GameFormat gameFormat,
  }) = _SettingsModel;

  void persistToSharedPreferences(SharedPreferences prefs) {
    prefs.setString("setting.scoutName", scoutName);
    prefs.setString("setting.eventName", eventName);
    prefs.setString("setting.selectedEvent", selectedEvent ?? '\u0000');
    prefs.setString("setting.themeMode", themeMode.name);
    prefs.setBool("setting.incrementMatchNumber", incrementMatchNumber);
    prefs.setString("setting.gameFormat", gameFormat.name);
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  factory SettingsModel.fromSharedPreferences(SharedPreferences prefs) {
    Map<String, dynamic> settings = {};
    for (final key in prefs.getKeys()) {
      if (key.startsWith("setting.")) {
        dynamic value = prefs.get(key) == '\u0000' ? null : prefs.get(key);
        settings[key.replaceFirst("setting.", "")] = value;
      }
    }
    return SettingsModel.fromJson(settings);
  }
}
