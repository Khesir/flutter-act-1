import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/pages/home/edit_form_page.dart';
import 'package:flutter_application_1/view/pages/home/form_page.dart';
import 'package:flutter_application_1/view/pages/home/home_page.dart';
import 'package:flutter_application_1/view/pages/userSettings/user_settings_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/create-player':
        return MaterialPageRoute(builder: (_) => FormPage());
      case '/edit-player':
        return MaterialPageRoute(
          builder: (_) => EditFormPage(),
          settings: settings,
        );
      case 'user-settings':
        return MaterialPageRoute(builder: (_) => UserSettingsPage()); 
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text("No route defined for ${settings.name}")),
          ),
        );
    }
  }
}
