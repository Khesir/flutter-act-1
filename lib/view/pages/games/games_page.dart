// lib/presentation/pages/all_games_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/layout/app_layout.dart';
import 'package:flutter_application_1/view/managers/game_manager.dart';
import 'package:provider/provider.dart';

class AllGamesPage extends StatefulWidget {
  const AllGamesPage({super.key});

  @override
  State<AllGamesPage> createState() => _AllGamesPageState();
}

class _AllGamesPageState extends State<AllGamesPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<GameManager>().loadGames());
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<GameManager>();
    final games = manager.games
        .where(
          (g) => g.title.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ),
        )
        .toList();

    return AppLayout(
      title: 'All Games',
      showBottomNav: true,
      currentIndex: 1,
      floatingActionButtonIcon: Icons.add,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search games by name or date',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return Dismissible(
                  key: Key(game.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (dir) async {
                    return await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Delete Game"),
                        content: const Text(
                          "Are you sure you want to delete this game?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) => manager.removeGame(game.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(game.title),
                    subtitle: Text(
                      "${game.schedules.first.startTime} - ${game.schedules.first.endTime}",
                    ),
                    trailing: Text("₱${game.totalCost.toStringAsFixed(2)}"),
                    onTap: () {
                      // Navigate to Edit Game page later
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      onFabPressed: () => Navigator.pushNamed(context, '/add-game'),
    );
  }
}
