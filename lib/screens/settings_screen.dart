import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/background_gradient.dart';
import '../core/game_theme.dart';
import '../core/sound_controller.dart';
import '../data/local_storage.dart';
import '../provider/theme_provider.dart';

enum SettingsKey {
  showHints,
  enableVibration,
  enableBackgroundParticles,
  enableStarTwinkling,
  musicVolume,
  soundEffectsVolume,
  starBrightness,
  selectedTheme,
  selectedDifficulty,
}

class SettingsDialog {
  static void show(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktopOrTablet = screenWidth > 600;

    if (isDesktopOrTablet) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal:
                screenWidth > 1200 ? screenWidth * 0.2 : screenWidth * 0.1,
            vertical: 40,
          ),
          child: const ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            child: SettingsScreen(isDialog: true),
          ),
        ),
      );
    } else {
      Navigator.pushNamed(context, '/settings');
    }
  }
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, this.isDialog = false});

  final bool isDialog;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Settings state
  bool _showHints = true;
  bool _enableVibration = true;
  bool _enableBackgroundParticles = true;
  bool _enableStarTwinkling = true;
  double _musicVolume = 0.7;
  double _soundEffectsVolume = 1.0;
  double _starBrightness = 0.8;
  String _selectedDifficulty = 'Normal';

  // Theme options
  late final List<String> _themes;
  final List<String> _difficulties = ['Easy', 'Normal', 'Hard', 'Expert'];

  @override
  void initState() {
    super.initState();
    _themes = GameTheme.values.map((e) => e.displayName).toList();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final storage = LocalStorage.instance;
    setState(() {
      _showHints = storage.getBool(SettingsKey.showHints.name) ?? true;
      _enableVibration =
          storage.getBool(SettingsKey.enableVibration.name) ?? true;
      _enableBackgroundParticles =
          storage.getBool(SettingsKey.enableBackgroundParticles.name) ?? true;
      _enableStarTwinkling =
          storage.getBool(SettingsKey.enableStarTwinkling.name) ?? true;
      _musicVolume = storage.getDouble(SettingsKey.musicVolume.name) ?? 0.7;
      _soundEffectsVolume =
          storage.getDouble(SettingsKey.soundEffectsVolume.name) ?? 1.0;
      _starBrightness =
          storage.getDouble(SettingsKey.starBrightness.name) ?? 0.8;
      _selectedDifficulty =
          storage.getString(SettingsKey.selectedDifficulty.name) ?? 'Normal';
    });
  }

  void _saveSetting<T>(SettingsKey key, T value) {
    final storage = LocalStorage.instance;
    if (value is bool) {
      storage.setBool(key.name, value);
    } else if (value is double) {
      storage.setDouble(key.name, value);
    } else if (value is String) {
      storage.setString(key.name, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(gameThemeProvider);
    final _selectedTheme = theme.displayName;

    return Scaffold(
      backgroundColor: Colors.black,
      body: BackgroundGradient(
        child: Stack(
          children: [
            // Background stars
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: StarfieldPainter(brightness: _starBrightness),
            ),

            // Settings content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            widget.isDialog
                                ? Icons.close_rounded
                                : Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            SoundController().playSound('click');
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Settings list
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildSection(
                          'Game Settings',
                          [
                            _buildDropdownSetting(
                              'Difficulty',
                              _selectedDifficulty,
                              _difficulties,
                              Icons.speed_rounded,
                              (value) {
                                setState(() {
                                  _selectedDifficulty = value!;
                                  _saveSetting(
                                      SettingsKey.selectedDifficulty, value);
                                });
                              },
                            ),
                            _buildSwitchSetting(
                              'Show Hints',
                              'Get visual guidance for constellations',
                              Icons.lightbulb_outline_rounded,
                              _showHints,
                              (value) {
                                setState(() {
                                  _showHints = value;
                                  _saveSetting(SettingsKey.showHints, value);
                                });
                              },
                            ),
                            _buildSwitchSetting(
                              'Vibration',
                              'Haptic feedback when connecting stars',
                              Icons.vibration_rounded,
                              _enableVibration,
                              (value) {
                                setState(() {
                                  _enableVibration = value;
                                  _saveSetting(
                                      SettingsKey.enableVibration, value);
                                });
                              },
                            ),
                          ],
                        ),
                        _buildSection(
                          'Visual Settings',
                          [
                            _buildDropdownSetting(
                              'Theme',
                              _selectedTheme,
                              _themes,
                              Icons.palette_rounded,
                              (value) {
                                final selectedTheme =
                                    GameTheme.values.firstWhere(
                                  (e) => e.displayName == value,
                                );
                                ref
                                    .read(gameThemeProvider.notifier)
                                    .setTheme(selectedTheme);
                                _saveSetting(SettingsKey.selectedTheme, value);
                              },
                            ),
                            // _buildSwitchSetting(
                            //   'Background Particles',
                            //   'Animated particles in the background',
                            //   Icons.auto_awesome_rounded,
                            //   _enableBackgroundParticles,
                            //   (value) {
                            //     setState(() {
                            //       _enableBackgroundParticles = value;
                            //       _saveSetting(
                            //           SettingsKey.enableBackgroundParticles,
                            //           value);
                            //     });
                            //   },
                            // ),
                            // _buildSwitchSetting(
                            //   'Star Twinkling',
                            //   'Animate stars with twinkling effect',
                            //   Icons.stars_rounded,
                            //   _enableStarTwinkling,
                            //   (value) {
                            //     setState(() {
                            //       _enableStarTwinkling = value;
                            //       _saveSetting(
                            //           SettingsKey.enableStarTwinkling, value);
                            //     });
                            //   },
                            // ),
                            // _buildSliderSetting(
                            //   'Star Brightness',
                            //   Icons.brightness_6_rounded,
                            //   _starBrightness,
                            //   (value) {
                            //     setState(() {
                            //       _starBrightness = value;
                            //       _saveSetting(
                            //         SettingsKey.starBrightness,
                            //         value,
                            //       );
                            //     });
                            //   },
                            // ),
                          ],
                        ),
                        _buildSection(
                          'Audio Settings',
                          [
                            _buildSliderSetting(
                              'Music Volume',
                              Icons.music_note_rounded,
                              _musicVolume,
                              (value) {
                                setState(() {
                                  _musicVolume = value;
                                  _saveSetting(SettingsKey.musicVolume, value);

                                  SoundController().setMusicVolume(value);
                                });
                              },
                            ),
                            _buildSliderSetting(
                              'Sound Effects',
                              Icons.volume_up_rounded,
                              _soundEffectsVolume,
                              (value) {
                                setState(() {
                                  _soundEffectsVolume = value;
                                  _saveSetting(
                                    SettingsKey.soundEffectsVolume,
                                    value,
                                  );

                                  SoundController()
                                      .setSoundEffectsVolume(value);
                                });
                              },
                            ),
                          ],
                        ),
                        _buildSection(
                          'About',
                          [
                            _buildInfoTile(
                              'Version',
                              '1.0.0',
                              Icons.info_outline_rounded,
                            ),
                            _buildButtonTile(
                              'Privacy Policy',
                              Icons.privacy_tip_rounded,
                              () {
                                launchUrl(Uri.parse(
                                  'https://taalaydev.github.io/files/constellation-provacy-policy.html',
                                ));
                              },
                            ),
                            _buildButtonTile(
                              'Terms of Service',
                              Icons.description_rounded,
                              () {
                                launchUrl(Uri.parse(
                                  'https://taalaydev.github.io/files/constellation-terms.html',
                                ));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.blue[300],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.05),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white54),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
          activeTrackColor: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    IconData icon,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(icon, color: Colors.white70),
            title: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Slider(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String value,
    List<String> options,
    IconData icon,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.05),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          dropdownColor: Colors.grey[900],
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          underline: Container(),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.05),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Text(
          value,
          style: const TextStyle(color: Colors.white54),
        ),
      ),
    );
  }

  Widget _buildButtonTile(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.05),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white54,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}

class StarfieldPainter extends CustomPainter {
  final double brightness;

  StarfieldPainter({this.brightness = 0.8});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent star pattern
    final paint = Paint()
      ..color = Colors.white.withOpacity(brightness * 0.5)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarfieldPainter oldDelegate) {
    return brightness != oldDelegate.brightness;
  }
}
