import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_router.dart';
import 'package:flutter_application_1/core/di.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DI.provideHomeManager()),
      ],
      child: MaterialApp(
        title: "Badminton Queuing System",
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
