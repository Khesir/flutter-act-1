// lib/domain/usecases/get_games.dart

import '../../entities/game.dart';
import '../../repositories/game_repository.dart';

class GetGames {
  final GameRepository repository;
  GetGames(this.repository);

  List<Game> call() => repository.getAllGames();
}
