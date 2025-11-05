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
      if (settings != null) {
        setState(() {
          _courtNameController.text = settings.defaultCourtName;
          _courtRateController.text = settings.defaultCourtRate.toString();
          _shuttlecockPriceController.text = settings.defaultShuttleCockPrice
              .toString();
          _divideEqually = settings.divideCourtEqually;
        });
      }
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

  void _addSchedule() async {
    DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (range != null) {
      setState(() {
        _schedules.add(
          GameSchedule(startTime: range.start, endTime: range.end),
        );
      });
    }
  }

  void _saveGame() {
    if (_formKey.currentState!.validate() && _schedules.isNotEmpty) {
      final manager = context.read<GameManager>();

      final newGame = Game(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.isNotEmpty
            ? _titleController.text
            : "Scheduled Game",
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ..._schedules.map(
                (s) => ListTile(
                  title: Text("${s.startTime} - ${s.endTime}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _schedules.remove(s);
                      });
                    },
                  ),
                ),
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
