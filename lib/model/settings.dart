import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scouting_app/consts.dart';
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
  }) = _SettingsModel;

  void persistToSharedPreferences(SharedPreferences prefs) {
    prefs.setString("setting.scoutName", scoutName);
    prefs.setString("setting.eventName", eventName);
    prefs.setString("setting.themeMode", themeMode.name);
    prefs.setBool("setting.incrementMatchNumber", incrementMatchNumber);
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  factory SettingsModel.fromSharedPreferences(SharedPreferences prefs) {
    return SettingsModel.fromJson({
      for (final key in prefs.getKeys())
        if (key.startsWith("setting."))
          key.replaceFirst("setting.", ""): prefs.get(key),
    });
  }
}
