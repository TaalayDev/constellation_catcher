import 'package:flutter/material.dart';

import '../screens/level_select_screen.dart';
import '../screens/game_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/achievments_screen.dart';
import '../data/local_storage.dart';

class AppRouter {
  static const String splash = '/';
  static const String menu = '/menu';
  static const String game = '/game';
  static const String levelSelect = '/level-select';
  static const String settings = '/settings';
  static const String achievements = '/achievements';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case menu:
        return MaterialPageRoute(
          builder: (_) => const MenuScreen(),
        );
      case game:
        final args = settings.arguments;

        return MaterialPageRoute(
          builder: (_) => GameScreen(
            levelIndex: (args as int?) ?? 0,
            mode: LocalStorage().getString('selectedDifficulty') ?? 'Normal',
          ),
        );
      case levelSelect:
        return MaterialPageRoute(
          builder: (_) => const LevelSelectScreen(),
        );
      case AppRouter.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case achievements:
        return MaterialPageRoute(
          builder: (_) => const AchievementScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
