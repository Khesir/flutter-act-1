import 'package:flutter_application_1/domain/repositories/player_repository.dart';
import 'package:flutter_application_1/domain/repositories/user_settings_repository.dart';
import 'package:flutter_application_1/domain/usecases/get_user_settings.dart';
import 'package:flutter_application_1/domain/usecases/product_usecases.dart';
import 'package:flutter_application_1/domain/usecases/save_user_settings.dart';
import 'package:flutter_application_1/view/managers/home_manager.dart';
import 'package:flutter_application_1/view/managers/user_setting_manager.dart';

// Dependency Injection
class DI {
  static PlayerRepository providePlayerRepository() =>
      InMemoryPlayerRepository();

  static UserSettingsRepository provideUserSettingsRepository() =>
      InMemoryUserSettingsRepository();


  static HomeManager provideHomeManager() => HomeManager(
    getPlayers: GetPlayers(providePlayerRepository()),
    addPlayer: AddPlayer(providePlayerRepository()),
    updatePlayer: UpdatePlayer(providePlayerRepository()),
    deletePlayer: DeletePlayer(providePlayerRepository()),
  );
  
  static UserSettingsManager provideUserSettingsManager() => UserSettingsManager(
    getUserSettings: GetUserSettings(provideUserSettingsRepository()),
    saveUserSettings: SaveUserSettings(provideUserSettingsRepository()));
}
