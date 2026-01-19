import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scouting_app/model/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

// Initialized in [main.dart]
@riverpod
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError();
}

@riverpod
class Settings extends _$Settings {
  @override
  SettingsModel build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return SettingsModel.fromSharedPreferences(prefs);
  }

  Future<void> updateSettings(SettingsModel settings) async {
    final prefs = ref.read(sharedPreferencesProvider);
    settings.persistToSharedPreferences(prefs);
    ref.invalidateSelf();
  }
}
