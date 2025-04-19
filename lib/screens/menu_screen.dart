import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/starfield_background.dart';
import '../provider/database_provider.dart';
import '../components/background_gradient.dart';
import '../core/sound_controller.dart';
import '../provider/interstitial_ad_controller.dart';
import 'settings_screen.dart';

class MenuScreen extends StatefulHookConsumerWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    SoundController().playBackgroundMusic(
      'game',
      fadeInDuration: const Duration(seconds: 8),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Pause background music if app is in background
      SoundController().pauseBackgroundMusic();
    } else if (state == AppLifecycleState.resumed) {
      // Resume background music when app comes back
      SoundController().resumeBackgroundMusic();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  Widget _buildMenu(BuildContext context, BoxConstraints constraints) {
    // Determine device type based on width
    final deviceWidth = constraints.maxWidth;
    final isDesktop = deviceWidth > 1200;
    final isTablet = deviceWidth > 600 && deviceWidth <= 1200;
    final isPhone = deviceWidth <= 600;

    final horizontalPadding = isDesktop
        ? deviceWidth * 0.3
        : isTablet
            ? deviceWidth * 0.1
            : 24.0;

    final menuWidth = isDesktop
        ? deviceWidth * 0.4
        : isTablet
            ? deviceWidth * 0.6
            : deviceWidth;

    final titleSize = isDesktop
        ? 56.0
        : isTablet
            ? 48.0
            : 40.0;
    final buttonTextSize = isDesktop
        ? 20.0
        : isTablet
            ? 18.0
            : 16.0;
    final scoreTextSize = isDesktop
        ? 28.0
        : isTablet
            ? 24.0
            : 20.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Center(
        child: SizedBox(
          width: menuWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: isDesktop
                    ? 48
                    : isTablet
                        ? 64
                        : 48,
              ),
              Text(
                'Constellation\nCatcher',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),

              const Spacer(),

              Column(
                children: [
                  _buildMenuButton(
                    'Play',
                    Icons.play_arrow_rounded,
                    () {
                      SoundController().playSound('click');
                      ref.watch(interstitialAdProvider.notifier).showAdIfLoaded(() {
                        Navigator.pushNamed(context, '/game');
                      });
                    },
                    buttonTextSize,
                    isDesktop,
                  ),
                  // SizedBox(height: isDesktop ? 24 : 16),
                  // _buildExpeditionButton(context, buttonTextSize, isDesktop),
                  SizedBox(height: isDesktop ? 24 : 16),
                  _buildMenuButton(
                    'Level Select',
                    Icons.grid_view_rounded,
                    () {
                      SoundController().playSound('click');
                      Navigator.pushNamed(context, '/level-select');
                    },
                    buttonTextSize,
                    isDesktop,
                  ),
                  SizedBox(height: isDesktop ? 24 : 16),
                  _buildMenuButton(
                    'Constellation Manual',
                    Icons.menu_book_rounded,
                    () {
                      SoundController().playSound('click');
                      Navigator.pushNamed(context, '/manual');
                    },
                    buttonTextSize,
                    isDesktop,
                  ),
                  SizedBox(height: isDesktop ? 24 : 16),
                  _buildMenuButton(
                    'Achievements',
                    Icons.emoji_events_rounded,
                    () {
                      SoundController().playSound('click');
                      Navigator.pushNamed(context, '/achievements');
                    },
                    buttonTextSize,
                    isDesktop,
                  ),
                  SizedBox(height: isDesktop ? 24 : 16),
                  _buildMenuButton(
                    'Settings',
                    Icons.settings_rounded,
                    () {
                      SoundController().playSound('click');
                      SettingsDialog.show(context);
                    },
                    buttonTextSize,
                    isDesktop,
                  ),
                  if (!kReleaseMode) ...[
                    SizedBox(height: isDesktop ? 24 : 16),
                    _buildMenuButton(
                      'Editor',
                      Icons.edit_rounded,
                      () => Navigator.pushNamed(context, '/editor'),
                      buttonTextSize,
                      isDesktop,
                    ),
                  ],
                ],
              ),

              const Spacer(),

              // High score section with responsive sizing
              Container(
                padding: EdgeInsets.all(isDesktop
                    ? 24
                    : isTablet
                        ? 24
                        : 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isDesktop ? 24 : 16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: isDesktop ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'High Score',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: buttonTextSize,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 16 : 8),
                    Consumer(builder: (context, ref, child) {
                      final database = ref.read(databaseProvider);
                      return FutureBuilder(
                        future: database.getStat('highScore'),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text(
                              'Loading...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: scoreTextSize,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }

                          final score = snapshot.data as int;
                          return Text(
                            score.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: scoreTextSize,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(
                  height: isDesktop
                      ? 32
                      : isTablet
                          ? 40
                          : 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    String title,
    IconData icon,
    VoidCallback onTap,
    double fontSize,
    bool isDesktop,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          SoundController().playSound('click');
          onTap();
        },
        borderRadius: BorderRadius.circular(isDesktop ? 24 : 16),
        child: Container(
          height: isDesktop ? 80 : 64,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(isDesktop ? 24 : 16),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: isDesktop ? 32 : 24),
              Icon(
                icon,
                color: Colors.white,
                size: isDesktop ? 32 : 24,
              ),
              SizedBox(width: isDesktop ? 24 : 16),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white54,
                size: isDesktop ? 32 : 24,
              ),
              SizedBox(width: isDesktop ? 32 : 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adLoaded = ref.watch(interstitialAdProvider);

    return Scaffold(
      body: BackgroundGradient(
        child: StarfieldBackground(
          starCount: 60,
          enableFallingStars: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SafeArea(child: _buildMenu(context, constraints));
            },
          ),
        ),
      ),
    );
  }
}
