
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/domain/entities/user_settings.dart';
import 'package:flutter_application_1/domain/usecases/get_user_settings.dart';
import 'package:flutter_application_1/domain/usecases/save_user_settings.dart';

class UserSettingsManager extends ChangeNotifier {
  final GetUserSettings getUserSettings;
  final SaveUserSettings saveUserSettings;

  late UserSettings _settings;

  UserSettingsManager({
    required this.getUserSettings,
    required this.saveUserSettings,
  }) {
    loadSettings();
  }

  UserSettings get settings => _settings;

  void loadSettings() {
    _settings = getUserSettings();
    notifyListeners();
  }

  void updateSettings(UserSettings newSettings) {
    _settings = newSettings;
    saveUserSettings(newSettings);
    notifyListeners();
  }
}
