// lib/domain/usecases/add_game.dart

import '../../entities/game.dart';
import '../../repositories/game_repository.dart';

class AddGame {
  final GameRepository repository;
  AddGame(this.repository);

  void call(Game game) => repository.addGame(game);
}
