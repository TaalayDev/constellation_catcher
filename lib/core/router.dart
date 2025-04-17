import 'package:flutter/material.dart';

import '../screens/constellation_editor_screen.dart';
import '../screens/constellation_expedition.dart';
import '../screens/level_select_screen.dart';
import '../screens/game_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/achievments_screen.dart';
import '../components/ad_wrapper.dart';
import '../data/local_storage.dart';

class AppRouter {
  static const String splash = '/';
  static const String menu = '/menu';
  static const String game = '/game';
  static const String expedition = '/expedition';
  static const String levelSelect = '/level-select';
  static const String settings = '/settings';
  static const String achievements = '/achievements';
  static const String constellationEditor = '/editor';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case menu:
        return MaterialPageRoute(
          builder: (_) => const AdWrapper(child: MenuScreen()),
        );
      case game:
        final args = settings.arguments;

        return MaterialPageRoute(
          builder: (_) => AdWrapper(
            child: GameScreen(
              levelIndex: (args as int?) ?? 0,
              mode: LocalStorage().getString('selectedDifficulty') ?? 'Normal',
            ),
          ),
        );
      case expedition:
        return MaterialPageRoute(
          builder: (_) => const AdWrapper(child: ExpeditionGameScreen()),
        );
      case levelSelect:
        return MaterialPageRoute(
          builder: (_) => const AdWrapper(
            child: LevelSelectScreen(),
          ),
        );
      case AppRouter.settings:
        return MaterialPageRoute(
          builder: (_) => const AdWrapper(child: SettingsScreen()),
        );
      case achievements:
        return MaterialPageRoute(
          builder: (_) => const AdWrapper(child: AchievementScreen()),
        );
      case constellationEditor:
        return MaterialPageRoute(
          builder: (_) => const ConstellationEditorScreen(),
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
