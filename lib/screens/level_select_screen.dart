import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/background_gradient.dart';
import '../core/sound_controller.dart';
import '../data/local_storage.dart';
import '../provider/interstitial_ad_controller.dart';

class LevelSelectScreen extends StatefulHookConsumerWidget {
  const LevelSelectScreen({super.key});

  @override
  ConsumerState<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends ConsumerState<LevelSelectScreen> {
  late final List<String> _completedLevels = LocalStorage().completedLevels;
  late final List<LevelInfo> _levels;

  @override
  void initState() {
    super.initState();
    fillLevels();
  }

  void fillLevels() {
    _levels = [
      LevelInfo(
        name: 'Triangulum',
        difficulty: 'Easy',
        stars: 3,
        description: 'A simple triangle constellation to get started',
        completed: _completedLevels.contains('Triangulum'),
        bestScore: 1250,
        unlocked: true,
      ),
      LevelInfo(
        name: 'Cassiopeia',
        difficulty: 'Medium',
        stars: 5,
        description: 'The queen\'s throne in the night sky',
        completed: _completedLevels.contains('Triangulum'),
        bestScore: 2100,
        unlocked: _completedLevels.contains('Triangulum'),
      ),
      LevelInfo(
        name: 'Ursa Minor',
        difficulty: 'Medium',
        stars: 7,
        description: 'The Little Bear points to the North Star',
        completed: _completedLevels.contains('Cassiopeia'),
        bestScore: 0,
        unlocked: _completedLevels.contains('Cassiopeia'),
      ),
      LevelInfo(
        name: 'Scorpius',
        difficulty: 'Hard',
        stars: 9,
        description: 'A mighty scorpion stretches across the sky',
        completed: _completedLevels.contains('Ursa Minor'),
        bestScore: 0,
        unlocked: _completedLevels.contains('Ursa Minor'),
      ),
      LevelInfo(
        name: 'Orion',
        difficulty: 'Expert',
        stars: 12,
        description: 'The great hunter strides through the stars',
        completed: _completedLevels.contains('Scorpius'),
        bestScore: 0,
        unlocked: _completedLevels.contains('Scorpius'),
      ),
      LevelInfo(
        name: 'Lyra',
        difficulty: 'Expert',
        stars: 15,
        description: 'The harp of the heavens sings a sweet melody',
        completed: _completedLevels.contains('Orion'),
        bestScore: 0,
        unlocked: _completedLevels.contains('Orion'),
      ),
      LevelInfo(
        name: 'Cygnus',
        difficulty: 'Expert',
        stars: 18,
        description: 'The swan glides gracefully through the Milky Way',
        completed: _completedLevels.contains('Lyra'),
        bestScore: 0,
        unlocked: _completedLevels.contains('Lyra'),
      ),
      LevelInfo(
        name: 'Perseus',
        difficulty: 'Expert',
        stars: 20,
        description: 'The hero holds the head of Medusa in the sky',
        completed: _completedLevels.contains('Cygnus'),
        bestScore: 0,
        unlocked: _completedLevels.contains('Cygnus'),
      ),
      LevelInfo(
        name: 'Pegasus',
        difficulty: 'Expert',
        stars: 22,
        description: 'The winged horse soars through the night',
        completed: _completedLevels.contains('Perseus'),
        bestScore: 0,
        unlocked: _completedLevels.contains('Perseus'),
      ),
      LevelInfo(
        name: 'Gemini',
        difficulty: 'Expert',
        stars: 25,
        description: 'The twins cast their gaze across the galaxy',
        completed: _completedLevels.contains('Pegasus'),
        bestScore: 0,
        unlocked: _completedLevels.contains('Pegasus'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BackgroundGradient(
        child: Stack(
          children: [
            // Background stars
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: StarfieldPainter(),
            ),

            // Main content
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
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            SoundController().playSound('click');
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Select Constellation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Level grid
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 200,
                      ),
                      itemCount: _levels.length,
                      itemBuilder: (context, index) {
                        final level = _levels[index];
                        return _LevelCard(
                          level: level,
                          onTap: level.unlocked
                              ? () {
                                  SoundController().playSound('click');
                                  ref.watch(interstitialAdProvider.notifier).showAdIfLoaded(() {
                                    Navigator.pushNamed(
                                      context,
                                      '/game',
                                      arguments: index,
                                    );
                                  });
                                }
                              : null,
                        );
                      },
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
}

class LevelInfo {
  final String name;
  final String difficulty;
  final int stars;
  final String description;
  final bool completed;
  final int bestScore;
  final bool unlocked;

  const LevelInfo({
    required this.name,
    required this.difficulty,
    required this.stars,
    required this.description,
    required this.completed,
    required this.bestScore,
    required this.unlocked,
  });
}

class _LevelCard extends StatelessWidget {
  final LevelInfo level;
  final VoidCallback? onTap;

  const _LevelCard({
    required this.level,
    this.onTap,
  });

  Color _getDifficultyColor() {
    switch (level.difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      case 'expert':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: level.unlocked ? Colors.white24 : Colors.white10,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(level.unlocked ? 0.1 : 0.05),
                  Colors.white.withOpacity(level.unlocked ? 0.05 : 0.02),
                ],
              ),
            ),
            child: Stack(
              children: [
                if (!level.unlocked)
                  Positioned.fill(
                    child: Center(
                      child: Icon(
                        Icons.lock_rounded,
                        size: 48,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          Text(
                            level.name,
                            style: TextStyle(
                              color: level.unlocked ? Colors.white : Colors.white38,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor().withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              level.difficulty,
                              style: TextStyle(
                                color: _getDifficultyColor(),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Star count
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: level.unlocked ? Colors.amber : Colors.white24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${level.stars} stars',
                            style: TextStyle(
                              color: level.unlocked ? Colors.white70 : Colors.white38,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Description
                      Text(
                        level.description,
                        style: TextStyle(
                          color: level.unlocked ? Colors.white54 : Colors.white24,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Status row
                      if (level.unlocked)
                        Row(
                          children: [
                            Icon(
                              level.completed ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                              size: 16,
                              color: level.completed ? Colors.green : Colors.white38,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              level.completed ? 'Completed' : 'Not completed',
                              style: TextStyle(
                                color: level.completed ? Colors.green : Colors.white38,
                                fontSize: 14,
                              ),
                            ),
                            if (level.completed) ...[
                              const Spacer(),
                              const Icon(
                                Icons.emoji_events_rounded,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Best: ${level.bestScore}',
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StarfieldPainter extends CustomPainter {
  final int starCount = 100;
  final List<Offset> stars;
  final List<double> starSizes;

  StarfieldPainter()
      : stars = List.generate(
          100,
          (_) => Offset(
            math.Random().nextDouble(),
            math.Random().nextDouble(),
          ),
        ),
        starSizes = List.generate(
          100,
          (_) => math.Random().nextDouble() * 2 + 1,
        );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < starCount; i++) {
      canvas.drawCircle(
        Offset(
          stars[i].dx * size.width,
          stars[i].dy * size.height,
        ),
        starSizes[i],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
