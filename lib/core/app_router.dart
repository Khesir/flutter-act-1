import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/pages/edit_form_page.dart';
import 'package:flutter_application_1/view/pages/form_page.dart';
import 'package:flutter_application_1/view/pages/home_page.dart';

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
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text("No route defined for ${settings.name}")),
          ),
        );
    }
  }
}
