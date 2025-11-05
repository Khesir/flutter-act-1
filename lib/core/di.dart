import 'package:flutter_application_1/domain/repositories/game_repository.dart';
import 'package:flutter_application_1/domain/repositories/player_repository.dart';
import 'package:flutter_application_1/domain/repositories/user_settings_repository.dart';
import 'package:flutter_application_1/domain/usecases/games/add_games.dart';
import 'package:flutter_application_1/domain/usecases/games/delete_games.dart';
import 'package:flutter_application_1/domain/usecases/games/get_games.dart';
import 'package:flutter_application_1/domain/usecases/games/update_games.dart';
import 'package:flutter_application_1/domain/usecases/get_user_settings.dart';
import 'package:flutter_application_1/domain/usecases/product_usecases.dart';
import 'package:flutter_application_1/domain/usecases/save_user_settings.dart';
import 'package:flutter_application_1/view/managers/game_manager.dart';
import 'package:flutter_application_1/view/managers/home_manager.dart';
import 'package:flutter_application_1/view/managers/user_setting_manager.dart';

// Dependency Injection
class DI {
  // Singleton Repositories
  static final PlayerRepository _playerRepository = InMemoryPlayerRepository();

  static final UserSettingsRepository _userSettingsRepository =
      InMemoryUserSettingsRepository();

  static final GameRepository _gameRepository = InMemoryGameRepository();

  static PlayerRepository providePlayerRepository() => _playerRepository;

  static UserSettingsRepository provideUserSettingsRepository() =>
      _userSettingsRepository;

  static GameRepository provideGameRepository() => _gameRepository;

  static HomeManager provideHomeManager() => HomeManager(
    getPlayers: GetPlayers(providePlayerRepository()),
    addPlayer: AddPlayer(providePlayerRepository()),
    updatePlayer: UpdatePlayer(providePlayerRepository()),
    deletePlayer: DeletePlayer(providePlayerRepository()),
  );

  static UserSettingsManager provideUserSettingsManager() =>
      UserSettingsManager(
        getUserSettings: GetUserSettings(provideUserSettingsRepository()),
        saveUserSettings: SaveUserSettings(provideUserSettingsRepository()),
      );

  static GameManager provideGameManager() => GameManager(
    getGames: GetGames(provideGameRepository()),
    addGame: AddGame(provideGameRepository()),
    updateGame: UpdateGame(provideGameRepository()),
    deleteGame: DeleteGame(provideGameRepository()),
  );
}
