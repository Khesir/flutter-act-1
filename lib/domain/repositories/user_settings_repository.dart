// lib/domain/repositories/user_settings_repository.dart

import '../entities/user_settings.dart';

abstract class UserSettingsRepository {
  UserSettings getSettings();
  void saveSettings(UserSettings settings);
}


class InMemoryUserSettingsRepository implements UserSettingsRepository {
  UserSettings _settings = UserSettings.defaultSettings;

  @override
  UserSettings getSettings() => _settings;

  @override
  void saveSettings(UserSettings settings) {
    _settings = settings;
  }
}
