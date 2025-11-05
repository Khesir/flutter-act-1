import '../../entities/game.dart';
import '../../repositories/game_repository.dart';

class UpdateGame {
  final GameRepository repository;
  UpdateGame(this.repository);

  void call(Game game) => repository.updateGame(game);
}
