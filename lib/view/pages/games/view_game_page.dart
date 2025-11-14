import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/game.dart';
import 'package:provider/provider.dart';
import '../../managers/game_manager.dart';

class ViewGamePage extends StatefulWidget {
  final String gameId;

  const ViewGamePage({super.key, required this.gameId});

  @override
  State<ViewGamePage> createState() => _ViewGamePageState();
}

class _ViewGamePageState extends State<ViewGamePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _courtNameController;
  late TextEditingController _courtRateController;
  late TextEditingController _shuttlecockPriceController;
  late bool _divideEqually;
  late List<GameSchedule> _schedules;
  late Game _currentGame;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final manager = context.read<GameManager>();
      manager.loadGames();
      final game = manager.games.firstWhere(
        (g) => g.id == widget.gameId,
        orElse: () => throw Exception('Game not found'),
      );

      setState(() {
        _currentGame = game;
        _titleController = TextEditingController(text: game.title);
        _courtNameController = TextEditingController(text: game.courtName);
        _courtRateController = TextEditingController(text: game.courtRate.toString());
        _shuttlecockPriceController = TextEditingController(text: game.shuttleCockPrice.toString());
        _divideEqually = game.divideEqually;
        _schedules = List.from(game.schedules);
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courtNameController.dispose();
    _courtRateController.dispose();
    _shuttlecockPriceController.dispose();
    super.dispose();
  }

  String _formatSchedule(GameSchedule schedule) {
    final dateFormat = '${schedule.startTime.year}-${schedule.startTime.month.toString().padLeft(2, '0')}-${schedule.startTime.day.toString().padLeft(2, '0')}';
    final startTime = '${schedule.startTime.hour.toString().padLeft(2, '0')}:${schedule.startTime.minute.toString().padLeft(2, '0')}';
    final endTime = '${schedule.endTime.hour.toString().padLeft(2, '0')}:${schedule.endTime.minute.toString().padLeft(2, '0')}';
    return '$dateFormat from $startTime to $endTime';
  }

  void _addSchedule() async {
    // Pick date first
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    // Pick start time
    final startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (startTime == null) return;

    // Pick end time
    final endTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: (startTime.hour + 2) % 24,
        minute: startTime.minute,
      ),
    );

    if (endTime == null) return;

    // Combine date with times
    final start = DateTime(
      date.year,
      date.month,
      date.day,
      startTime.hour,
      startTime.minute,
    );

    final end = DateTime(
      date.year,
      date.month,
      date.day,
      endTime.hour,
      endTime.minute,
    );

    // Validate that end is after start
    if (end.isBefore(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("End time must be after start time")),
      );
      return;
    }

    setState(() {
      _schedules.add(GameSchedule(startTime: start, endTime: end));
    });
  }

  void _saveGame() {
    if (_formKey.currentState!.validate() && _schedules.isNotEmpty) {
      final manager = context.read<GameManager>();

      // Generate default title from first schedule date if title is blank
      String gameTitle;
      if (_titleController.text.isNotEmpty) {
        gameTitle = _titleController.text;
      } else {
        final firstSchedule = _schedules.first.startTime;
        gameTitle = '${firstSchedule.year}-${firstSchedule.month.toString().padLeft(2, '0')}-${firstSchedule.day.toString().padLeft(2, '0')} Game';
      }

      final updatedGame = _currentGame.copyWith(
        title: gameTitle,
        courtName: _courtNameController.text,
        schedules: _schedules,
        courtRate: double.tryParse(_courtRateController.text) ?? 0.0,
        shuttleCockPrice: double.tryParse(_shuttlecockPriceController.text) ?? 0.0,
        divideEqually: _divideEqually,
      );

      manager.editGame(updatedGame);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Game updated successfully")),
      );
    } else if (_schedules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one schedule")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_titleController.text.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("View Game")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? "Edit Game" : "View Game"),
        actions: [
          if (!_isEditMode)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditMode = true;
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Game Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Game Title",
                  hintText: "Leave blank to use default title",
                ),
                enabled: _isEditMode,
              ),
              const SizedBox(height: 10),

              // Court Name
              TextFormField(
                controller: _courtNameController,
                decoration: const InputDecoration(labelText: "Court Name"),
                validator: (value) =>
                    value!.isEmpty ? "Court name is required" : null,
                enabled: _isEditMode,
              ),
              const SizedBox(height: 10),

              // Court Rate
              TextFormField(
                controller: _courtRateController,
                decoration: const InputDecoration(
                  labelText: "Court Rate (₱ per hour)",
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Court rate is required" : null,
                enabled: _isEditMode,
              ),
              const SizedBox(height: 10),

              // Shuttlecock Price
              TextFormField(
                controller: _shuttlecockPriceController,
                decoration: const InputDecoration(
                  labelText: "Shuttlecock Price (₱ per game)",
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Price is required" : null,
                enabled: _isEditMode,
              ),
              const SizedBox(height: 10),

              // Divide Equally Checkbox
              CheckboxListTile(
                title: const Text("Divide the court equally among players"),
                value: _divideEqually,
                onChanged: _isEditMode
                    ? (val) => setState(() => _divideEqually = val!)
                    : null,
              ),
              const SizedBox(height: 10),

              // Player Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Game Information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 20),
                          const SizedBox(width: 8),
                          Text('${_currentGame.numberOfPlayers} players'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 20),
                          const SizedBox(width: 8),
                          Text('${_currentGame.totalHours.toStringAsFixed(1)} hours'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.attach_money, size: 20, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            '₱${_currentGame.totalCost.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Schedules List
              const Text(
                "Schedules",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ..._schedules.asMap().entries.map(
                (entry) {
                  final index = entry.key;
                  final s = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text(_formatSchedule(s)),
                      subtitle: Text('Duration: ${s.hours.toStringAsFixed(1)} hours'),
                      trailing: _isEditMode
                          ? IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _schedules.remove(s);
                                });
                              },
                            )
                          : null,
                    ),
                  );
                },
              ),
              if (_isEditMode)
                ElevatedButton.icon(
                  onPressed: _addSchedule,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Schedule"),
                ),
              const SizedBox(height: 30),

              // Action Buttons
              if (_isEditMode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text("Save Changes"),
                      onPressed: _saveGame,
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.cancel),
                      label: const Text("Cancel"),
                      onPressed: () {
                        setState(() {
                          _isEditMode = false;
                          // Reset fields to original values
                          _titleController.text = _currentGame.title;
                          _courtNameController.text = _currentGame.courtName;
                          _courtRateController.text = _currentGame.courtRate.toString();
                          _shuttlecockPriceController.text = _currentGame.shuttleCockPrice.toString();
                          _divideEqually = _currentGame.divideEqually;
                          _schedules = List.from(_currentGame.schedules);
                        });
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
