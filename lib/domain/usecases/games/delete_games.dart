import '../../repositories/game_repository.dart';

class DeleteGame {
  final GameRepository repository;
  DeleteGame(this.repository);

  void call(String id) => repository.deleteGame(id);
}
