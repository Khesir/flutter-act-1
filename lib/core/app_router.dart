import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/di.dart';
import 'package:flutter_application_1/view/pages/games/add_game_page.dart';
import 'package:flutter_application_1/view/pages/games/games_page.dart';
import 'package:flutter_application_1/view/pages/games/view_game_page.dart';
import 'package:flutter_application_1/view/pages/home/edit_form_page.dart';
import 'package:flutter_application_1/view/pages/home/form_page.dart';
import 'package:flutter_application_1/view/pages/home/home_page.dart';
import 'package:flutter_application_1/view/pages/userSettings/user_settings_page.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: DI.provideHomeManager(),
            child: HomePage(),
          ),
        );
      case '/create-player':
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: DI.provideHomeManager(),
            child: FormPage(),
          ),
        );
      case '/edit-player':
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: DI.provideHomeManager(),
            child: EditFormPage(),
          ),
          settings: settings,
        );
      case '/user-settings':
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: DI.provideUserSettingsManager(),
            child: UserSettingsPage(),
          ),
        );

      case '/games':
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: DI.provideGameManager(),
            child: AllGamesPage(),
          ),
        );
      case '/add-game':
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: DI.provideGameManager()),
              ChangeNotifierProvider.value(
                value: DI.provideUserSettingsManager(),
              ),
            ],
            child: AddGamePage(),
          ),
        );

      case '/view-game':
        final gameId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: DI.provideGameManager(),
            child: ViewGamePage(gameId: gameId),
          ),
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
