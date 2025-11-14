import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/game.dart';
import 'package:flutter_application_1/view/managers/user_setting_manager.dart';
import 'package:provider/provider.dart';
import '../../managers/game_manager.dart';

class AddGamePage extends StatefulWidget {
  const AddGamePage({super.key});

  @override
  State<AddGamePage> createState() => _AddGamePageState();
}

class _AddGamePageState extends State<AddGamePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _courtNameController = TextEditingController();
  final _courtRateController = TextEditingController();
  final _shuttlecockPriceController = TextEditingController();
  bool _divideEqually = true;
  List<GameSchedule> _schedules = [];

  @override
  void initState() {
    super.initState();

    // Load default settings
    Future.microtask(() {
      context.read<UserSettingsManager>().loadSettings();
      final settings = context.read<UserSettingsManager>().settings;
      setState(() {
        _courtNameController.text = settings.defaultCourtName;
        _courtRateController.text = settings.defaultCourtRate.toString();
        _shuttlecockPriceController.text = settings.shuttleCockPrice.toString();
        _divideEqually = settings.divideCourtEqually;
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

      final newGame = Game(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: gameTitle,
        courtName: _courtNameController.text,
        schedules: _schedules,
        courtRate: double.tryParse(_courtRateController.text) ?? 0.0,
        shuttleCockPrice:
            double.tryParse(_shuttlecockPriceController.text) ?? 0.0,
        divideEqually: _divideEqually,
        players: [],
      );

      manager.addNewGame(newGame);
      Navigator.pop(context);
    } else if (_schedules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one schedule")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Game")),
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
              ),
              const SizedBox(height: 10),

              // Court Name
              TextFormField(
                controller: _courtNameController,
                decoration: const InputDecoration(labelText: "Court Name"),
                validator: (value) =>
                    value!.isEmpty ? "Court name is required" : null,
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
              ),
              const SizedBox(height: 10),

              // Divide Equally Checkbox
              CheckboxListTile(
                title: const Text("Divide the court equally among players"),
                value: _divideEqually,
                onChanged: (val) => setState(() => _divideEqually = val!),
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
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _schedules.remove(s);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              ElevatedButton.icon(
                onPressed: _addSchedule,
                icon: const Icon(Icons.add),
                label: const Text("Add Schedule"),
              ),
              const SizedBox(height: 30),

              // Action Buttons
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
                    label: const Text("Save Game"),
                    onPressed: _saveGame,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
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
