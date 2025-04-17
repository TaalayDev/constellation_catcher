import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'provider/theme_provider.dart';
import 'core/sound_controller.dart';
import 'core/router.dart';
import 'data/local_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initWindowManager();

  await dotenv.load(fileName: ".env");

  await LocalStorage.init();
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await MobileAds.instance.initialize();
  }

  SoundController().setMusicVolume(
    LocalStorage().getDouble('musicVolume') ?? 0.3,
  );
  SoundController().setSoundEffectsVolume(
    LocalStorage().getDouble('soundEffectsVolume') ?? 0.5,
  );

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

Future<void> initWindowManager() async {
  if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
    return;
  }

  const size = Size(600, 1000);
  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    maximumSize: size,
    minimumSize: size,
    size: size,
    center: true,
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'Palette Master',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
