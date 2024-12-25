import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/sound_controller.dart';
import '../data/database.dart';
import '../components/background_gradient.dart';
import '../provider/database_provider.dart';

class AchievementScreen extends ConsumerStatefulWidget {
  const AchievementScreen({super.key});

  @override
  ConsumerState<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends ConsumerState<AchievementScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'In Progress', 'Completed'];

  @override
  Widget build(BuildContext context) {
    final achievementsStream = ref.watch(databaseProvider).watchAchievements();

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

            // Content
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
                          'Achievements',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        StreamBuilder<List<PlayerAchievement>>(
                          stream: achievementsStream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox.shrink();
                            }
                            return _buildProgressIndicator(snapshot.data!);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(
                              filter,
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.black : Colors.blueGrey,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() => _selectedFilter = filter);
                            },
                            backgroundColor: Colors.white.withOpacity(0.1),
                            selectedColor: Colors.white,
                            checkmarkColor: Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Achievements list
                  Expanded(
                    child: StreamBuilder<List<PlayerAchievement>>(
                        stream: achievementsStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final achievements = snapshot.data!;
                          final filteredAchievements = _filterAchievements(
                            achievements,
                            _selectedFilter,
                          );

                          return GridView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredAchievements.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 500,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              mainAxisExtent: 155,
                            ),
                            itemBuilder: (context, index) {
                              final achievement = filteredAchievements[index];

                              return AchievementCard(
                                achievement: achievement,
                                index: index,
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PlayerAchievement> _filterAchievements(
    List<PlayerAchievement> achievements,
    String filter,
  ) {
    switch (filter) {
      case 'Completed':
        return achievements.where((a) => a.progress >= a.total).toList();
      case 'In Progress':
        return achievements
            .where((a) => a.progress > 0 && a.progress < a.total)
            .toList();
      default:
        return achievements;
    }
  }

  Widget _buildProgressIndicator(List<PlayerAchievement> achievements) {
    final completed = achievements.where((a) => a.progress >= a.total).length;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            color: Colors.amber,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '$completed/${achievements.length}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class Achievement {
  final String name;
  final String description;
  final IconData icon;
  final int progress;
  final int total;
  final AchievementRarity rarity;
  final bool unlocked;

  Achievement({
    required this.name,
    required this.description,
    required this.icon,
    required this.progress,
    required this.total,
    required this.rarity,
    required this.unlocked,
  });

  bool get isComplete => progress >= total;
  double get progressPercentage => progress / total;
}

enum AchievementRarity {
  common,
  rare,
  epic,
  legendary;

  Color get color {
    switch (this) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.rare:
        return Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange;
    }
  }

  String get label => name[0].toUpperCase() + name.substring(1);
}

class AchievementCard extends StatelessWidget {
  final PlayerAchievement achievement;
  final int index;

  const AchievementCard({
    super.key,
    required this.achievement,
    required this.index,
  });

  Color get rarityColor {
    switch (achievement.rarity.toLowerCase()) {
      case 'common':
        return Colors.grey;
      case 'rare':
        return Colors.blue;
      case 'epic':
        return Colors.purple;
      case 'legendary':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String get rarityLabel =>
      achievement.rarity[0].toUpperCase() + achievement.rarity.substring(1);

  bool get isComplete => achievement.progress >= achievement.total;
  double get progressPercentage => achievement.progress / achievement.total;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: index * 100),
        ),
        SlideEffect(
          begin: const Offset(0, 0.1),
          end: const Offset(0, 0),
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: index * 100),
        ),
      ],
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: rarityColor.withOpacity(0.3),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Achievement content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icon container
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: rarityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        achievement.icon,
                        color: rarityColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Achievement details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Title and rarity
                          Row(
                            children: [
                              Text(
                                achievement.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: rarityColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  rarityLabel,
                                  style: TextStyle(
                                    color: rarityColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Description
                          Text(
                            achievement.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Progress bar
                          Stack(
                            children: [
                              // Background
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              // Progress
                              FractionallySizedBox(
                                widthFactor: progressPercentage,
                                child: Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: rarityColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Progress text
                          Text(
                            '${achievement.progress}/${achievement.total}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Completion overlay
              if (isComplete)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent star pattern
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
