// lib/presentation/pages/user_settings_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/user_settings.dart';
import 'package:flutter_application_1/view/managers/user_setting_manager.dart';
import 'package:provider/provider.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _courtNameController;
  late TextEditingController _courtRateController;
  late TextEditingController _shuttleCockController;
  bool _divideCourtEqually = true;

  @override
  void initState() {
    super.initState();
    final settings = context.read<UserSettingsManager>().settings;
    _courtNameController =
        TextEditingController(text: settings.defaultCourtName);
    _courtRateController =
        TextEditingController(text: settings.defaultCourtRate.toString());
    _shuttleCockController =
        TextEditingController(text: settings.shuttleCockPrice.toString());
    _divideCourtEqually = settings.divideCourtEqually;
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<UserSettingsManager>();

    return Scaffold(
      appBar: AppBar(title: const Text("User Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _courtNameController,
                decoration: const InputDecoration(labelText: "Default Court Name"),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _courtRateController,
                decoration: const InputDecoration(labelText: "Default Court Rate"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    double.tryParse(v ?? '') == null ? 'Enter a valid number' : null,
              ),
              TextFormField(
                controller: _shuttleCockController,
                decoration: const InputDecoration(labelText: "Shuttle Cock Price"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    double.tryParse(v ?? '') == null ? 'Enter a valid number' : null,
              ),
              CheckboxListTile(
                title: const Text("Divide court equally among players"),
                value: _divideCourtEqually,
                onChanged: (v) => setState(() => _divideCourtEqually = v!),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newSettings = UserSettings(
                      defaultCourtName: _courtNameController.text,
                      defaultCourtRate: double.parse(_courtRateController.text),
                      shuttleCockPrice: double.parse(_shuttleCockController.text),
                      divideCourtEqually: _divideCourtEqually,
                    );
                    manager.updateSettings(newSettings);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Settings saved!")),
                    );
                  }
                },
                child: const Text("Save Settings"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
