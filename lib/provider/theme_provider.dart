import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/local_storage.dart';
import '../core/game_theme.dart';
import '../core/theme.dart';

final gameThemeProvider =
    StateNotifierProvider<GameThemeNotifier, GameTheme>((ref) {
  return GameThemeNotifier();
});

class GameThemeNotifier extends StateNotifier<GameTheme> {
  GameThemeNotifier() : super(GameTheme.classic) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = LocalStorage.instance;
    final themeName =
        prefs.getString('selectedTheme') ?? GameTheme.classic.displayName;
    state = GameTheme.values.firstWhere(
      (theme) => theme.displayName == themeName,
      orElse: () => GameTheme.classic,
    );
  }

  Future<void> setTheme(GameTheme theme) async {
    final prefs = LocalStorage.instance;
    prefs.setString('selectedTheme', theme.displayName);
    state = theme;
  }

  ThemeConfig get currentTheme => ThemeConfig.forTheme(state);
  AppTheme get appTheme => AppTheme.fromType(state);
}

extension GameThemeExtension on GameTheme {
  ThemeConfig get config => ThemeConfig.forTheme(this);
  AppTheme get appTheme => AppTheme.fromType(this);
}
