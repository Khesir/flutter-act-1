import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/usecases/product_usecases.dart';
import '../../domain/entities/player.dart';

class HomeManager extends ChangeNotifier {
  final GetPlayers getPlayers;
  final AddPlayer addPlayer;
  final DeletePlayer deletePlayer;
  final UpdatePlayer updatePlayer;

  List<Player> _players = [];
  List<Player> _filteredPlayers = [];
  bool _loading = false;

  HomeManager({
    required this.getPlayers,
    required this.addPlayer,
    required this.deletePlayer,
    required this.updatePlayer,
  });

  List<Player> get players =>
      _filteredPlayers.isEmpty ? _players : _filteredPlayers;
  bool get loading => _loading;

  loadPlayer() {
    _loading = true;
    notifyListeners();
    _players = [];
    _players.addAll(getPlayers());
    debugPrint(_players[0].nickname);
    _filteredPlayers = [];
    _loading = false;
    notifyListeners();
  }

  addPlayerQuery(Player player) {
    _loading = true;
    notifyListeners();
    addPlayer(player);
    _players.add(player);
    _filteredPlayers = [];
    _loading = false;
    notifyListeners();
  }

  updatePlayerQuery(Player player) {
    _loading = true;
    notifyListeners();

    updatePlayer(player);

    // Update in-memory list
    final index = _players.indexWhere((p) => p.id == player.id);
    if (index != -1) {
      _players[index] = player;
    }

    _filteredPlayers = [];
    _loading = false;
    notifyListeners();
  }

  deletePlayerQuery(String id) {
    _players.removeWhere((p) => p.id == id);
    _filteredPlayers.removeWhere((p) => p.id == id);
    notifyListeners();

    deletePlayer(id);
  }

  search(String query) {
    if (query.isEmpty) {
      _filteredPlayers = [];
    } else {
      final lower = query.toLowerCase();
      _filteredPlayers = _players.where((p) {
        return p.nickname.toLowerCase().contains(lower) ||
            p.fullName.toLowerCase().contains(lower);
      }).toList();
    }
    notifyListeners();
  }
}
