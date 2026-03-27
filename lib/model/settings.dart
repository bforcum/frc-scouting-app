import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
@JsonSerializable()
class SettingsModel with _$SettingsModel {
  @override
  final String? scoutName;
  @override
  final String? eventCode;
  @override
  final String? selectedEvent;
  @override
  final bool incrementMatchNumber;
  @override
  final bool scoutingLead;
  @override
  final ThemeMode themeMode;
  @override
  final GameFormat gameFormat;

  const SettingsModel({
    this.scoutName,
    this.eventCode,
    this.selectedEvent,
    this.incrementMatchNumber = true,
    this.scoutingLead = false,
    this.themeMode = ThemeMode.system,
    this.gameFormat = GameFormat.v2026v2,
  });

  void persistToSharedPreferences(SharedPreferences prefs) {
    prefs.setString("setting.scoutName", scoutName ?? '\u0000');
    prefs.setString("setting.eventCode", eventCode ?? '\u0000');
    prefs.setString("setting.selectedEvent", selectedEvent ?? '\u0000');
    prefs.setString("setting.themeMode", themeMode.name);
    prefs.setBool("setting.incrementMatchNumber", incrementMatchNumber);
    prefs.setBool("setting.scoutingLead", scoutingLead);
    prefs.setString("setting.gameFormat", gameFormat.name);
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);
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
