// lib/presentation/pages/all_games_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/game.dart';
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

  String _formatSchedules(List<GameSchedule> schedules) {
    if (schedules.isEmpty) return 'No schedules';

    if (schedules.length == 1) {
      final s = schedules.first;
      final date = '${s.startTime.year}-${s.startTime.month.toString().padLeft(2, '0')}-${s.startTime.day.toString().padLeft(2, '0')}';
      final start = '${s.startTime.hour.toString().padLeft(2, '0')}:${s.startTime.minute.toString().padLeft(2, '0')}';
      final end = '${s.endTime.hour.toString().padLeft(2, '0')}:${s.endTime.minute.toString().padLeft(2, '0')}';
      return '$date from $start to $end';
    }

    // Multiple schedules - show first one and count
    final s = schedules.first;
    final date = '${s.startTime.year}-${s.startTime.month.toString().padLeft(2, '0')}-${s.startTime.day.toString().padLeft(2, '0')}';
    final start = '${s.startTime.hour.toString().padLeft(2, '0')}:${s.startTime.minute.toString().padLeft(2, '0')}';
    return '$date at $start (+${schedules.length - 1} more)';
  }

  void _navigateToAddGame() async {
    await Navigator.pushNamed(context, '/add-game');
    // Reload games when returning from add game page
    if (mounted) {
      context.read<GameManager>().loadGames();
    }
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
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(
                        game.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            _formatSchedules(game.schedules),
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.people, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${game.numberOfPlayers} players',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.attach_money, size: 16, color: Colors.green[700]),
                              const SizedBox(width: 4),
                              Text(
                                '₱${game.totalCost.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          '/view-game',
                          arguments: game.id,
                        );
                        // Reload games when returning from view game page
                        if (mounted) {
                          context.read<GameManager>().loadGames();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      onFabPressed: _navigateToAddGame,
    );
  }
}
