// lib/domain/usecases/get_user_settings.dart

import '../entities/user_settings.dart';
import '../repositories/user_settings_repository.dart';

class GetUserSettings {
  final UserSettingsRepository repository;
  GetUserSettings(this.repository);

  UserSettings call() => repository.getSettings();
}
