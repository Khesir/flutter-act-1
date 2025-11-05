// lib/presentation/managers/game_manager.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/domain/entities/game.dart';
import 'package:flutter_application_1/domain/usecases/games/add_games.dart';
import 'package:flutter_application_1/domain/usecases/games/delete_games.dart';
import 'package:flutter_application_1/domain/usecases/games/get_games.dart';
import 'package:flutter_application_1/domain/usecases/games/update_games.dart';

class GameManager extends ChangeNotifier {
  final GetGames getGames;
  final AddGame addGame;
  final UpdateGame updateGame;
  final DeleteGame deleteGame;

  List<Game> _games = [];
  bool _loading = false;

  GameManager({
    required this.getGames,
    required this.addGame,
    required this.updateGame,
    required this.deleteGame,
  });

  List<Game> get games => _games;
  bool get loading => _loading;

  void loadGames() {
    _loading = true;
    notifyListeners();
    _games = getGames();
    _loading = false;
    notifyListeners();
  }

  void addNewGame(Game game) {
    debugPrint(game.courtName);
    addGame(game);
    _games = getGames();
    loadGames();
    notifyListeners();
  }

  void editGame(Game game) {
    updateGame(game);
    loadGames();
    notifyListeners();
  }

  void removeGame(String id) {
    deleteGame(id);
    loadGames();
    notifyListeners();
  }
}
