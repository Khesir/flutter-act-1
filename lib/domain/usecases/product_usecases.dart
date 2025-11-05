import '../entities/player.dart';
import '../repositories/player_repository.dart';

class GetPlayers {
  final PlayerRepository repo;
  GetPlayers(this.repo);

  List<Player> call() => repo.getPlayers();
}

class AddPlayer {
  final PlayerRepository repo;
  AddPlayer(this.repo);

  void call(Player player) => repo.addPlayer(player);
}

class DeletePlayer {
  final PlayerRepository repo;
  DeletePlayer(this.repo);

  void call(String id) => repo.deletePlayer(id);
}

class UpdatePlayer {
  final PlayerRepository repo;
  UpdatePlayer(this.repo);

  void call(Player updatedPlayer) => repo.updatePlayer(updatedPlayer);
}
