import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/player.dart';
import 'package:flutter_application_1/view/layout/app_layout.dart';
import 'package:flutter_application_1/view/managers/home_manager.dart';
import 'package:provider/provider.dart';

class EditFormPage extends StatefulWidget {
  const EditFormPage({super.key});

  @override
  State<StatefulWidget> createState() => _EditFormPageState();
}

class _EditFormPageState extends State<EditFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nicknameController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _remarkController = TextEditingController();
  late Player player;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Player) {
      player = args;

      _nicknameController.text = player.nickname;
      _fullnameController.text = player.fullName;
      _mobileController.text = player.contactNumber;
      _emailController.text = player.email;
      _addressController.text = player.address;
      _remarkController.text = player.remarks;
      _levelRange = player.skillLevel;
    } else {
      Navigator.pop(context);
    }
  }

  RangeValues _levelRange = const RangeValues(1, 3);
  String _levelTickLabel(double value) {
    int v = value.round();
    String level;
    if (v <= 3) {
      level = "Beginner";
    } else if (v <= 6) {
      level = "Intermediate";
    } else if (v <= 9) {
      level = "Level G";
    } else if (v <= 12) {
      level = "Level F";
    } else if (v <= 15) {
      level = "Level E";
    } else if (v <= 18) {
      level = "Level D";
    } else {
      level = "Open";
    }

    int tickIndex = (v - 1) % 3;
    String tick;
    switch (tickIndex) {
      case 0:
        tick = "Weak";
        break;
      case 1:
        tick = "Mid";
        break;
      default:
        tick = "Strong";
    }

    return "$level-$tick";
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Player saved successfully")),
      );
      context.read<HomeManager>().updatePlayerQuery(
        Player(
          id: (player.id).toString(),
          nickname: _nicknameController.text,
          fullName: _fullnameController.text,
          contactNumber: _mobileController.text,
          email: _emailController.text,
          address: _addressController.text,
          remarks: _remarkController.text,
          skillLevel: _levelRange,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fix validation errors")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<HomeManager>();
    return AppLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 20,
        title: Text(
          "New Player",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: Colors.blueGrey[600],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: _saveForm,
              child: const Text(
                "Update User",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      loading: manager.loading,
      body: Container(
        color: Colors.grey[200],
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nickname input
                    TextFormField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(
                        labelText: "Nickname",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person, color: Colors.blue),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Nickname is required"
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Full name input
                    TextFormField(
                      controller: _fullnameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge, color: Colors.blue),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Full name is required"
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Mobile Number
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Mobile Number",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone, color: Colors.blue),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Mobile number is required";
                        }
                        final pattern = RegExp(r'^\d+$');
                        if (!pattern.hasMatch(v)) return "Enter a valid number";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email, color: Colors.blue),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Email is required";
                        final pattern = RegExp(
                          r'^[^@]+@[^@]+\.[^@]+',
                        ); // basic email regex
                        if (!pattern.hasMatch(v)) return "Enter a valid email";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Address
                    TextFormField(
                      controller: _addressController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: "Home Address",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.pin_drop, color: Colors.blue),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Address is required" : null,
                    ),
                    const SizedBox(height: 16),

                    // Remarks
                    TextFormField(
                      controller: _remarkController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: "Remarks",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.menu_book_outlined,
                          color: Colors.blue,
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Address is required" : null,
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Skill Level",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            showValueIndicator: ShowValueIndicator.onDrag,
                            activeTrackColor: Colors.blue,
                            inactiveTrackColor: Colors.blue[100],
                            thumbColor: Colors.blue,
                            overlayColor: Colors.blue.withOpacity(0.2),
                            valueIndicatorColor: Colors.blueAccent,
                            valueIndicatorTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: RangeSlider(
                            values: _levelRange,
                            min: 1,
                            max: 21,
                            divisions: 20,
                            labels: RangeLabels(
                              _levelTickLabel(_levelRange.start),
                              _levelTickLabel(_levelRange.end),
                            ),
                            onChanged: (values) {
                              setState(() => _levelRange = values);
                            },
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(21, (index) {
                            final tickLabel = ["W", "M", "S"][index % 3];
                            return Text(
                              tickLabel,
                              style: const TextStyle(fontSize: 10),
                            );
                          }),
                        ),

                        const SizedBox(height: 2),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: const Text(
                                  "Beginner",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: const Text(
                                  "Intermediate",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: const Text(
                                  "Level G",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: const Text(
                                  "Level F",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: const Text(
                                  "Level E",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: const Text(
                                  "Level D",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: const Text(
                                  "Open",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

