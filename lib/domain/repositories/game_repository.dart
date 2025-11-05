// lib/domain/repositories/game_repository.dart

import 'package:flutter_application_1/utils/uuid_generator.dart';

import '../entities/game.dart';

abstract class GameRepository {
  List<Game> getAllGames();
  void addGame(Game game);
  void updateGame(Game game);
  void deleteGame(String id);
}
// lib/data/repositories/in_memory_game_repository.dart

class InMemoryGameRepository implements GameRepository {
  final List<Game> _games = [];

  @override
  List<Game> getAllGames() => List.unmodifiable(_games);

  @override
  void addGame(Game game) {
    _games.add(game.copyWith(id: IdGenerator.generate()));
  }

  @override
  void updateGame(Game updatedGame) {
    final index = _games.indexWhere((g) => g.id == updatedGame.id);
    if (index != -1) _games[index] = updatedGame;
  }

  @override
  void deleteGame(String id) {
    _games.removeWhere((g) => g.id == id);
  }
}
