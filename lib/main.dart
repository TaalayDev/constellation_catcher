import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'data/local_storage.dart';
import 'config/router.dart';
import 'config/sound_controller.dart';
import 'provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorage.init();
  SoundController()
      .setMusicVolume(LocalStorage().getDouble('musicVolume') ?? 0.3);
  SoundController().setSoundEffectsVolume(
      LocalStorage().getDouble('soundEffectsVolume') ?? 0.5);

  // Force portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    // Set system overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    runApp(const ProviderScope(child: ConstellationCatcher()));
  });
}

class ConstellationCatcher extends HookConsumerWidget {
  const ConstellationCatcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(gameThemeProvider);

    useEffect(() {
      return () {
        SoundController().dispose();
      };
    }, const []);

    return MaterialApp(
      title: 'Constellation Catcher',
      theme: theme.appTheme.themeData,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.splash,
      debugShowCheckedModeBanner: false,
    );
  }
}
