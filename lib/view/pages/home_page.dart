import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/layout/app_layout.dart';
import 'package:provider/provider.dart';
import '../managers/home_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Color getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load players once
    Future.microtask(() => context.read<HomeManager>().loadPlayer());
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<HomeManager>();

    return AppLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 20,
        title: Text(
          "All Players",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: Colors.blueGrey[600],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/create-player");
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      loading: manager.loading,
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                hintText: "Search by name or nick name",
                hintStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => context.read<HomeManager>().search(value),
            ),
          ),

          // Player List
          Expanded(
            child: manager.players.isEmpty
                ? const Center(child: Text("No players found"))
                : ListView.builder(
                    itemCount: manager.players.length,
                    itemBuilder: (context, index) {
                      final player = manager.players[index];

                      // Determine borders for first/last item
                      BorderSide borderSide = const BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      );
                      Border border = Border(
                        top: index == 0 ? borderSide : BorderSide.none,
                        bottom: index == manager.players.length - 1
                            ? borderSide
                            : BorderSide.none,
                        left: borderSide,
                        right: borderSide,
                      );

                      return Dismissible(
                        key: ValueKey(player.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 0,
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Confirm Delete"),
                              content: Text(
                                "Are you sure you want to delete ${player.nickname}?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );
                          return confirm == true;
                        },
                        onDismissed: (_) {
                          context.read<HomeManager>().deletePlayerQuery(
                            player.id,
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/edit-player",
                              arguments: player,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 0,
                            ),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: border,
                              borderRadius: BorderRadius.only(
                                topLeft: index == 0
                                    ? Radius.circular(10)
                                    : Radius.zero,
                                topRight: index == 0
                                    ? Radius.circular(10)
                                    : Radius.zero,
                                bottomLeft: index == manager.players.length - 1
                                    ? Radius.circular(10)
                                    : Radius.zero,
                                bottomRight: index == manager.players.length - 1
                                    ? Radius.circular(10)
                                    : Radius.zero,
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: getRandomColor(),
                                child: Text(
                                  player.nickname.isNotEmpty
                                      ? player.nickname[0].toUpperCase()
                                      : "?",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Text(
                                player.nickname,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey[800],
                                ),
                              ),
                              subtitle: Text(
                                "${player.fullName} • ${player.skillLevelString}",
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
