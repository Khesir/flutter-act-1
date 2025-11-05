// implements inmemory, api,etc.
import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/player.dart';

abstract class PlayerRepository {
  List<Player> getPlayers();
  void addPlayer(Player player);
  void deletePlayer(String id);
  void updatePlayer(Player updatedPlayer);
}

class InMemoryPlayerRepository implements PlayerRepository {
  final List<Player> _players = [];

  InMemoryPlayerRepository() {
    _players.addAll([
      Player(
        id: "0",
        nickname: "Ace",
        fullName: "John Carter",
        contactNumber: "09171234567",
        email: "john.carter@example.com",
        address: "123 Main St, Metro City",
        remarks: "Captain of Team Alpha",
        skillLevel: RangeValues(1, 5),
      ),
      Player(
        id: "1",
        nickname: "Shadow",
        fullName: "Emily Davis",
        contactNumber: "09182345678",
        email: "emily.davis@example.com",
        address: "456 Oak St, Greenfield",
        remarks: "Prefers stealth roles",
        skillLevel: RangeValues(1, 5),
      ),
      Player(
        id: "2",
        nickname: "Blaze",
        fullName: "Michael Lee",
        contactNumber: "09193456789",
        email: "michael.lee@example.com",
        address: "789 Pine St, Riverside",
        remarks: "Aggressive playstyle",
        skillLevel: RangeValues(1, 5),
      ),
    ]);
  }

  @override
  List<Player> getPlayers() => List.unmodifiable(_players);

  @override
  void addPlayer(Player player) => _players.add(player);

  @override
  void deletePlayer(String id) => _players.removeWhere((p) => p.id == id);

  @override
  void updatePlayer(Player updatePlayer) {
    final index = _players.indexWhere((p) => p.id == updatePlayer.id);
    if (index != -1) {
      _players[index] = updatePlayer;
    }
  }
}
