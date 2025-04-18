import 'dart:async';
import 'dart:math' as math;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../components/background_gradient.dart';
import '../components/dialogs/constellation_complete_dialog.dart';
import '../core/sound_controller.dart';
import '../data/constellation_data.dart';
import '../models/constellation_level.dart';
import '../provider/database_provider.dart';
import '../provider/interstitial_ad_controller.dart';
import '../data/local_storage.dart';
import '../components/dialogs/continue_game_dialog.dart';
import '../components/toast.dart';

enum GameDifficulty {
  easy,
  normal,
  hard;

  String get displayName {
    switch (this) {
      case GameDifficulty.easy:
        return 'Easy';
      case GameDifficulty.normal:
        return 'Normal';
      case GameDifficulty.hard:
        return 'Hard';
    }
  }

  int get timeLimit {
    switch (this) {
      case GameDifficulty.easy:
        return 90;
      case GameDifficulty.normal:
        return 60;
      case GameDifficulty.hard:
        return 30;
    }
  }

  int get scoreMultiplier {
    switch (this) {
      case GameDifficulty.easy:
        return 1;
      case GameDifficulty.normal:
        return 2;
      case GameDifficulty.hard:
        return 3;
    }
  }
}

Offset _calculateStarPosition(Offset position, Size size) {
  return Offset(position.dx * size.width, position.dy * size.height);
}

class GameScreen extends StatefulHookConsumerWidget {
  const GameScreen({
    super.key,
    this.levelIndex = 0,
    this.mode = 'Normal',
  });

  final int levelIndex;
  final String mode;

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> with TickerProviderStateMixin {
  late List<AnimatedGameStar> _backgroundStars;
  int _currentStarIndex = -1;
  int _currentLevel = 0;
  Offset? _currentDragPosition;
  List<int> _completedIndices = [];
  bool _isDragging = false;
  bool _showHint = false;
  int _score = 0;
  bool _levelComplete = false;

  // Difficulty settings
  late GameDifficulty _difficulty;

  // Star animation controllers
  int _mistakes = 0;
  late int _remainingTime;
  int _comboMultiplier = 1;
  int _consecutiveCorrect = 0;
  bool _powerUpActive = false;
  Timer? _gameTimer;
  bool _isTimeFreeze = false;

  // Hint system
  int _hintsRemaining = 3;

  // Power-up states and cooldowns
  late bool _hasTimeFreeze;
  late bool _hasStarReveal;
  late bool _hasPathClear;

  Timer? _timeFreezeTimer;
  Timer? _starRevealTimer;
  Timer? _pathClearTimer;

  int _timeFreezeCD = 0;
  int _starRevealCD = 0;
  int _pathClearCD = 0;

  // Animations
  late final AnimationController _hintController;
  late final AnimationController _powerUpController;
  late final AnimationController _comboController;
  late final AnimationController _mistakeController;
  final List<AnimationController> _starAnimationControllers = [];

  // Game state
  List<List<int>> _playerConnections = [];
  bool _isValidating = false;
  bool _isPaused = false;

  List<ConstellationLevel> get _levels => ConstellationDataService.levels;
  ConstellationLevel get level => _levels[_currentLevel];
  bool get _isClosedLoop => level.isClosedLoop;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.levelIndex;
    _initializeDifficulty();
    _initializeGame();
    _initializeAnimations();
    _startGameTimer();

    FirebaseAnalytics.instance.logEvent(
      name: 'game_started',
      parameters: {
        'level': _currentLevel,
        'difficulty': _difficulty.displayName,
      },
    );
  }

  void _initializeDifficulty() {
    switch (widget.mode) {
      case 'Easy':
        _difficulty = GameDifficulty.easy;
        break;
      case 'Hard':
        _difficulty = GameDifficulty.hard;
        break;
      case 'Normal':
      default:
        _difficulty = GameDifficulty.normal;
        break;
    }

    _remainingTime = _difficulty.timeLimit;

    // Set power-ups based on difficulty
    _hasTimeFreeze = _difficulty != GameDifficulty.hard;
    _hasStarReveal = _difficulty == GameDifficulty.easy;
    _hasPathClear = _difficulty != GameDifficulty.hard;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeBackgroundStars();
  }

  void _initializeAnimations() {
    _powerUpController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _comboController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _hintController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _mistakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _initializeBackgroundStars() {
    final size = MediaQuery.of(context).size;
    final starCount = (size.width * size.height / 5000).round().clamp(50, 300);

    final random = math.Random();
    _backgroundStars = List.generate(starCount, (index) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 1500 + random.nextInt(1500)),
        vsync: this,
      );

      _starAnimationControllers.add(controller);
      controller
        ..forward()
        ..repeat(reverse: true);

      return AnimatedGameStar(
        position: Offset(
          random.nextDouble(),
          random.nextDouble(),
        ),
        size: random.nextDouble() * 2 + 1,
        twinkleAnimation: controller,
        rotationSpeed: random.nextDouble() * 0.02,
        pulseSize: random.nextDouble() * 0.5 + 0.5,
      );
    });
  }

  void _initializeGame() {
    setState(() {
      _currentStarIndex = -1;
      _completedIndices = [];
      _score = 0;
      _mistakes = 0;
      _comboMultiplier = 1;
      _consecutiveCorrect = 0;
      _levelComplete = false;
      _playerConnections = [];
      _hintsRemaining = 3;

      _timeFreezeCD = 0;
      _starRevealCD = 0;
      _pathClearCD = 0;
    });
  }

  void _startGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      if (!_isTimeFreeze) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            _endGame(completed: false);
            _showContinueGameDialog();
          }
        });
      }

      // Update cooldowns
      setState(() {
        if (_timeFreezeCD > 0) _timeFreezeCD--;
        if (_starRevealCD > 0) _starRevealCD--;
        if (_pathClearCD > 0) _pathClearCD--;
      });
    });
  }

  void _pauseGame() {
    setState(() {
      _isPaused = true;
    });
    SoundController().pauseBackgroundMusic();
  }

  void _resumeGame() {
    setState(() {
      _isPaused = false;
    });
    SoundController().resumeBackgroundMusic();
  }

  // Power-up implementations
  void _activateTimeFreeze() {
    if (_timeFreezeCD > 0) {
      _showAdForPowerUp('time_freeze');
      return;
    }

    if (!_hasTimeFreeze) return;

    setState(() {
      _isTimeFreeze = true;
      _timeFreezeCD = 30; // 30 second cooldown
      _powerUpController.forward(from: 0);
    });

    HapticFeedback.mediumImpact();
    SoundController().playSound('connect');

    showToast(context, 'Time Frozen for 5 seconds!');

    _timeFreezeTimer?.cancel();
    _timeFreezeTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        _isTimeFreeze = false;
      });
      showToast(context, 'Time resumed!');
    });

    FirebaseAnalytics.instance.logEvent(
      name: 'power_up_used',
      parameters: {'type': 'time_freeze'},
    );
  }

  void _activateStarReveal() {
    if (_starRevealCD > 0) {
      _showAdForPowerUp('star_reveal');
      return;
    }

    if (!_hasStarReveal) return;

    setState(() {
      _showHint = true;
      _powerUpActive = true;
      _starRevealCD = 20; // 20 second cooldown
      _powerUpController.forward(from: 0);
    });

    HapticFeedback.mediumImpact();
    SoundController().playSound('connect');

    showToast(context, 'Path revealed for 3 seconds!');

    _starRevealTimer?.cancel();
    _starRevealTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _showHint = false;
        _powerUpActive = false;
      });
    });

    FirebaseAnalytics.instance.logEvent(
      name: 'power_up_used',
      parameters: {'type': 'star_reveal'},
    );
  }

  void _activatePathClear() {
    if (_pathClearCD > 0) {
      _showAdForPowerUp('path_clear');
      return;
    }

    if (!_hasPathClear) return;

    setState(() {
      _pathClearCD = 25; // 25 second cooldown
      _powerUpController.forward(from: 0);
    });

    HapticFeedback.mediumImpact();
    SoundController().playSound('connect');

    showToast(context, 'Decoy stars cleared for 2 seconds!');

    FirebaseAnalytics.instance.logEvent(
      name: 'power_up_used',
      parameters: {'type': 'path_clear'},
    );
  }

  void _showAdForPowerUp(String powerUpType) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        title: const Text(
          'Power-up on Cooldown',
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This power-up is on cooldown. Watch an ad to use it now?',
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _pauseGame();

              // Show ad then activate power-up
              ref.read(interstitialAdProvider.notifier).showAdIfLoaded(() {
                _resumeGame();

                switch (powerUpType) {
                  case 'time_freeze':
                    setState(() {
                      _timeFreezeCD = 0;
                      _activateTimeFreeze();
                    });
                    break;
                  case 'star_reveal':
                    setState(() {
                      _starRevealCD = 0;
                      _activateStarReveal();
                    });
                    break;
                  case 'path_clear':
                    setState(() {
                      _pathClearCD = 0;
                      _activatePathClear();
                    });
                    break;
                }
              });

              FirebaseAnalytics.instance.logEvent(
                name: 'ad_watched',
                parameters: {'reason': 'power_up_cooldown'},
              );
            },
            child: const Text(
              'Watch Ad',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showHintWithAd() {
    if (_hintsRemaining > 0) {
      setState(() {
        _hintsRemaining--;
        _showHint = true;
      });

      _hintController.forward(from: 0).then((_) {
        setState(() => _showHint = false);
      });

      HapticFeedback.lightImpact();
      SoundController().playSound('click');
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          title: const Text(
            'Out of Hints',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You\'ve used all your hints. Watch an ad to get 3 more hints?',
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _pauseGame();

                // Show ad then give hints
                ref.read(interstitialAdProvider.notifier).showAdIfLoaded(() {
                  _resumeGame();
                  setState(() {
                    _hintsRemaining = 3;
                    _showHint = true;
                  });

                  _hintController.forward(from: 0).then((_) {
                    setState(() => _showHint = false);
                  });
                });

                FirebaseAnalytics.instance.logEvent(
                  name: 'ad_watched',
                  parameters: {'reason': 'refill_hints'},
                );
              },
              child: const Text(
                'Watch Ad',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _endGame({required bool completed}) {
    _gameTimer?.cancel();
    _timeFreezeTimer?.cancel();
    _starRevealTimer?.cancel();
    _pathClearTimer?.cancel();

    final timeBonus = _remainingTime * 10 * _difficulty.scoreMultiplier;
    final finalScore = _score + timeBonus;

    setState(() {
      _levelComplete = completed;
      _score = finalScore;
    });

    if (completed) {
      // Add level to completed levels
      final completedLevels = LocalStorage().completedLevels;
      if (!completedLevels.contains(level.name)) {
        LocalStorage().completedLevels = [
          ...completedLevels,
          level.name,
        ];
      }

      FirebaseAnalytics.instance.logEvent(
        name: 'level_completed',
        parameters: {
          'level': level.name,
          'score': finalScore,
          'time_taken': _difficulty.timeLimit - _remainingTime,
          'difficulty': _difficulty.displayName,
        },
      );

      _showCompletionDialog();
    }
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _timeFreezeTimer?.cancel();
    _starRevealTimer?.cancel();
    _pathClearTimer?.cancel();

    _powerUpController.dispose();
    _comboController.dispose();
    _hintController.dispose();
    _mistakeController.dispose();

    for (var controller in _starAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  double _getStarRadius(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return (size.shortestSide * 0.006).clamp(6.0, 8.0);
  }

  EdgeInsets _getResponsivePadding(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.width > 1200) {
      return EdgeInsets.symmetric(horizontal: size.width * 0.2, vertical: 16);
    } else if (size.width > 600) {
      return EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: 16);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  }

  Widget _buildGameUI(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar with responsive layout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _difficulty.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Score: $_score',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isWideScreen ? 20 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.lightbulb_outline,
                          color: Colors.white,
                        ),
                        onPressed: _showHintWithAd,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade700,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$_hintsRemaining',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          Padding(
            padding: _getResponsivePadding(context),
            child: _levelComplete ? const SizedBox() : _buildLevelInfoUI(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelInfoUI(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWideScreen ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (!isWideScreen)
            Text(
              _levels[_currentLevel].name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (!isWideScreen) const SizedBox(height: 8),
          Text(
            'Connect the stars in sequence to complete the constellation',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isWideScreen ? 18 : 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerUpButton({
    required IconData icon,
    required bool available,
    required int cooldown,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: available ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: available
                      ? cooldown > 0
                          ? Colors.white.withOpacity(0.1)
                          : Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: available
                      ? cooldown > 0
                          ? Colors.white.withOpacity(0.5)
                          : Colors.white
                      : Colors.white38,
                  size: 24,
                ),
              ),
              if (cooldown > 0)
                Positioned.fill(
                  child: CircularProgressIndicator(
                    value: 1 - (cooldown / (cooldown > 20 ? 30 : 20)),
                    strokeWidth: 2,
                    backgroundColor: Colors.white10,
                    color: Colors.white30,
                  ),
                ),
              if (cooldown > 0)
                Positioned.fill(
                  child: Center(
                    child: Text(
                      '$cooldown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComboIndicator() {
    if (_comboMultiplier <= 1) return const SizedBox.shrink();

    return ScaleTransition(
      scale: _comboController.drive(CurveTween(curve: Curves.elasticOut)).drive(Tween(begin: 0.8, end: 1.0)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade700,
              Colors.red.shade600,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              'COMBO x$_comboMultiplier',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetLevel() {
    setState(() {
      _playerConnections.clear();
      _currentStarIndex = -1;
      _currentDragPosition = null;
      _isDragging = false;
      _isValidating = false;
      _levelComplete = false;
      _remainingTime = _difficulty.timeLimit;
      _comboMultiplier = 1;
      _consecutiveCorrect = 0;
      _mistakes = 0;
      _hintsRemaining = 3;

      _timeFreezeCD = 0;
      _starRevealCD = 0;
      _pathClearCD = 0;
    });

    _startGameTimer();
  }

  void _startNextLevel() {
    setState(() {
      _currentLevel = (_currentLevel + 1) % _levels.length;
      _resetLevel();
    });
  }

  void _showCompletionDialog() {
    final timeBonus = _remainingTime * 10 * _difficulty.scoreMultiplier;
    final mistakePenalty = _mistakes * 50;
    final finalScore = _score + timeBonus - mistakePenalty;

    final timeTaken = Duration(
      seconds: _difficulty.timeLimit - _remainingTime,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConstellationCompletionDialog(
        constellationName: _levels[_currentLevel].name,
        score: finalScore,
        timeTaken: timeTaken,
        onContinue: () {
          Navigator.pop(context); // Close the dialog
          if (_currentLevel < _levels.length - 1) {
            setState(() => _startNextLevel());
          } else {
            Navigator.pushReplacementNamed(context, '/level-select');
          }
        },
      ),
    );

    _saveProgress(finalScore);
  }

  void _showContinueGameDialog() {
    _pauseGame();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ContinueGameDialog(
        isTimeOut: _remainingTime <= 0,
        onWatchAd: () {
          Navigator.pop(context);

          ref.read(interstitialAdProvider.notifier).showAdIfLoaded(() {
            setState(() {
              _mistakes = 0;
              if (_remainingTime < _difficulty.timeLimit) {
                _remainingTime = _difficulty.timeLimit;
              } else {
                // Give a small time bonus as a reward
                _remainingTime += 10;
              }
            });
            _resumeGame();

            showToast(context, 'Lives refilled! +10 seconds bonus');
          });

          FirebaseAnalytics.instance.logEvent(
            name: 'ad_watched',
            parameters: {'reason': 'continue_game'},
          );
        },
        onRestart: () {
          Navigator.pop(context);
          _resetLevel();
          _resumeGame();
        },
        onQuit: () {
          Navigator.pop(context); // Close dialog
          Navigator.pop(context); // Return to previous screen
        },
      ),
    );
  }

  Future<void> _saveProgress(int finalScore) async {
    final db = ref.read(databaseProvider);

    // Update stats
    await db.incrementStat('totalConstellationsCompleted');
    await db.incrementStat('totalStarsConnected', level.starPositions.length);

    // Update high score if necessary
    final currentHighScore = await db.getStat('highScore');
    if (finalScore > currentHighScore) {
      await db.setStat('highScore', finalScore);
    }

    // Update achievements
    await db.updateAchievementProgress('Stargazer', 1);

    if (_mistakes == 0) {
      await db.updateAchievementProgress('Perfect Draw', 1);
    }

    final timeTaken = _difficulty.timeLimit - _remainingTime;
    if (timeTaken <= 10) {
      await db.updateAchievementProgress('Speed Demon', 1);
    }

    await db.updateAchievementProgress(
      'Star Collector',
      level.starPositions.length,
    );

    await db.updateAchievementProgress('Constellation Master', 1);

    if (_difficulty == GameDifficulty.hard) {
      await db.updateAchievementProgress('Cosmic Explorer', 1);
    }
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
              painter: AnimatedBackgroundStarsPainter(
                stars: _backgroundStars,
                starRadius: _getStarRadius(context),
              ),
            ),

            // Main constellation game area
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800, maxHeight: 800),
                child: LayoutBuilder(builder: (context, constraints) {
                  final isWideScreen = constraints.maxWidth > 600;
                  final size = Size(
                    constraints.maxWidth,
                    !isWideScreen ? constraints.maxHeight * 0.6 : constraints.maxHeight,
                  );

                  return GestureDetector(
                    onPanStart: (details) => _handleDragStart(details, size),
                    onPanUpdate: (details) => _handleDragUpdate(details, size),
                    onPanEnd: _handleDragEnd,
                    child: CustomPaint(
                      size: size,
                      painter: AdaptiveConstellationPainter(
                        constellation: level.starPositions,
                        connections: level.connections,
                        currentIndex: _currentStarIndex,
                        completedIndices: _completedIndices,
                        currentDragPosition: _currentDragPosition,
                        showHint: _showHint,
                        hintAnimation: _hintController,
                        isComplete: _levelComplete,
                        starRadius: _getStarRadius(context),
                        lineWidth: MediaQuery.of(context).size.width * 0.004,
                        isClosedLoop: _isClosedLoop,
                        playerConnections: _playerConnections,
                        showPathClear: _pathClearCD == 0 && _hasPathClear,
                      ),
                    ),
                  );
                }),
              ),
            ),

            // UI elements
            _buildGameUI(context),

            // Combo indicator
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: _buildComboIndicator(),
              ),
            ),

            // Power-ups overlay
            Positioned(
              top: 60,
              right: 16,
              child: SafeArea(
                child: Column(
                  children: [
                    _buildPowerUpButton(
                      icon: Icons.ac_unit,
                      available: _hasTimeFreeze,
                      cooldown: _timeFreezeCD,
                      onTap: _activateTimeFreeze,
                      tooltip: 'Freeze Time (5s)',
                    ),
                    const SizedBox(height: 8),
                    _buildPowerUpButton(
                      icon: Icons.visibility,
                      available: _hasStarReveal,
                      cooldown: _starRevealCD,
                      onTap: _activateStarReveal,
                      tooltip: 'Reveal Path (3s)',
                    ),
                    const SizedBox(height: 8),
                    _buildPowerUpButton(
                      icon: Icons.clear_all,
                      available: _hasPathClear,
                      cooldown: _pathClearCD,
                      onTap: _activatePathClear,
                      tooltip: 'Clear Path (2s)',
                    ),
                  ],
                ),
              ),
            ),

            // Game stats overlay
            Positioned(
              top: 60,
              left: 16,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStat('Time', '$_remainingTime s'),
                    _buildStat('Combo', '${_comboMultiplier}x'),
                    _buildStat(
                      'Mistakes',
                      '$_mistakes/3',
                    ).animate(
                      controller: _mistakeController,
                      effects: [
                        ShakeEffect(
                          duration: 300.ms,
                          hz: 4,
                          curve: Curves.easeInOut,
                        ),
                        ColorEffect(
                          begin: Colors.red.withOpacity(0.1),
                          end: Colors.white.withOpacity(0.1),
                          duration: 300.ms,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDragStart(DragStartDetails details, Size screenSize) {
    if (_levelComplete || _isPaused) return;

    final starRadius = _getStarRadius(context);

    for (int i = 0; i < level.starPositions.length; i++) {
      final starPos = level.starPositions[i];
      final targetPixelPosition = _calculateStarPosition(starPos, screenSize);

      if ((targetPixelPosition - details.localPosition).distance < starRadius * 2) {
        setState(() {
          _isDragging = true;
          _currentDragPosition = details.localPosition;
          _currentStarIndex = i;
        });
        HapticFeedback.lightImpact();
        break;
      }
    }
  }

  void _handleDragUpdate(DragUpdateDetails details, Size screenSize) {
    if (!_isDragging || _levelComplete || _isPaused) return;

    setState(() {
      _currentDragPosition = details.localPosition;
    });

    final starRadius = _getStarRadius(context);

    for (int i = 0; i < level.starPositions.length; i++) {
      if (i == _currentStarIndex) continue;

      final targetPos = level.starPositions[i];
      final targetPixelPosition = _calculateStarPosition(targetPos, screenSize);

      if ((targetPixelPosition - details.localPosition).distance < starRadius * 2) {
        // Check if not already connected to this star in current drag
        if (!_playerConnections.any((conn) =>
            (conn[0] == _currentStarIndex && conn[1] == i) || (conn[1] == _currentStarIndex && conn[0] == i))) {
          _playerConnections.add([_currentStarIndex, i]);

          setState(() {
            _currentStarIndex = i;
          });

          HapticFeedback.lightImpact();
          SoundController().playSound('connect');

          if (_isValidConnection(_currentStarIndex, i)) {
            _consecutiveCorrect++;
            if (_consecutiveCorrect >= 3) {
              setState(() {
                _comboMultiplier = math.min(4, (_consecutiveCorrect ~/ 3));
              });

              // Show combo animation
              _comboController.forward(from: 0);

              // Score points for valid connection
              _score += 10 * _comboMultiplier * _difficulty.scoreMultiplier;

              showToast(context, '+${10 * _comboMultiplier * _difficulty.scoreMultiplier} points!');
            }
          }
          return;
        }
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging || _isPaused) return;

    setState(() {
      _isDragging = false;
      _currentDragPosition = null;
    });

    _validatePattern();
  }

  void _validatePattern() {
    if (_playerConnections.isEmpty) return;
    print('${_playerConnections}');

    setState(() {
      _isValidating = true;
    });

    // Check if all required connections are made
    final requiredConnections = Set<String>();
    for (final connection in level.connections) {
      requiredConnections.add('${connection[0]}-${connection[1]}');
      requiredConnections.add('${connection[1]}-${connection[0]}');
    }

    final userConnections = Set<String>();
    for (final connection in _playerConnections) {
      userConnections.add('${connection[0]}-${connection[1]}');
      userConnections.add('${connection[1]}-${connection[0]}');
    }

    // Check if all required connections are made (subset)
    final allConnectionsValid = requiredConnections.containsAll(userConnections);

    if (allConnectionsValid) {
      _handleCorrectPattern();
    } else {
      _handleIncorrectPattern();
    }

    setState(() {
      _isValidating = false;
    });
  }

  bool _isValidConnection(int fromIndex, int toIndex) {
    for (final connection in level.connections) {
      if ((connection[0] == fromIndex && connection[1] == toIndex) ||
          (connection[1] == fromIndex && connection[0] == toIndex)) {
        return true;
      }
    }
    return false;
  }

  void _handleCorrectPattern() {
    // Check if all required connections are made
    final requiredConnections = level.connections.length;
    final uniquePlayerConnections =
        _playerConnections.map((c) => c[0] < c[1] ? '${c[0]}-${c[1]}' : '${c[1]}-${c[0]}').toSet();

    // Check if player has made all required connections
    bool patternComplete = uniquePlayerConnections.length >= requiredConnections;

    if (patternComplete) {
      setState(() {
        _levelComplete = true;
        _score += 100 * _comboMultiplier * _difficulty.scoreMultiplier;
      });

      HapticFeedback.mediumImpact();
      SoundController().playSound('success');

      _endGame(completed: true);
    } else {
      setState(() {
        _consecutiveCorrect++;
        if (_consecutiveCorrect >= 3) {
          _comboMultiplier = math.min(4, _consecutiveCorrect ~/ 3);
          _comboController.forward(from: 0);
        }
      });
    }
  }

  void _handleIncorrectPattern() {
    setState(() {
      _mistakes++;
      _consecutiveCorrect = 0;
      _comboMultiplier = 1;
      _playerConnections.clear();
      _mistakeController.forward(from: 0);
    });

    HapticFeedback.heavyImpact();

    if (_mistakes >= 3) {
      _showContinueGameDialog();
    }
  }
}

class AnimatedGameStar {
  final Offset position;
  final double size;
  final AnimationController twinkleAnimation;
  final double rotationSpeed;
  final double pulseSize;

  AnimatedGameStar({
    required this.position,
    required this.size,
    required this.twinkleAnimation,
    required this.rotationSpeed,
    required this.pulseSize,
  });
}

class AnimatedBackgroundStarsPainter extends CustomPainter {
  final List<AnimatedGameStar> stars;
  final double starRadius;

  AnimatedBackgroundStarsPainter({
    required this.stars,
    required this.starRadius,
  }) : super(
          repaint: Listenable.merge(
            stars.map((star) => star.twinkleAnimation).toList(),
          ),
        );

  @override
  void paint(Canvas canvas, Size size) {
    final time = DateTime.now().millisecondsSinceEpoch / 1000;

    for (final star in stars) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(
          0.3 + 0.7 * star.twinkleAnimation.value,
        )
        ..style = PaintingStyle.fill;

      final position = Offset(
        star.position.dx * size.width,
        star.position.dy * size.height,
      );

      final pulseOffset = math.sin(time * star.rotationSpeed) * star.pulseSize;
      final currentSize = star.size * (1 + pulseOffset * 0.3);

      final glowPaint = Paint()
        ..color = Colors.white.withOpacity(0.1 * star.twinkleAnimation.value)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(position, currentSize * 2, glowPaint);
      canvas.drawCircle(position, currentSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AdaptiveConstellationPainter extends CustomPainter {
  final List<Offset> constellation;
  final List<List<int>> connections;
  final int currentIndex;
  final List<int> completedIndices;
  final Offset? currentDragPosition;
  final bool showHint;
  final AnimationController hintAnimation;
  final bool isComplete;
  final double starRadius;
  final double lineWidth;
  final bool isClosedLoop;
  final List<List<int>> playerConnections;
  final bool showPathClear;

  AdaptiveConstellationPainter({
    required this.constellation,
    required this.connections,
    required this.currentIndex,
    required this.completedIndices,
    required this.currentDragPosition,
    required this.showHint,
    required this.hintAnimation,
    required this.isComplete,
    required this.starRadius,
    required this.lineWidth,
    required this.isClosedLoop,
    this.playerConnections = const [],
    this.showPathClear = false,
  }) : super(repaint: hintAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    final hintPaint = Paint()
      ..color = Colors.white.withOpacity(0.3 * (1 - hintAnimation.value))
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    final validConnectionPaint = Paint()
      ..color = Colors.green.withOpacity(0.7)
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    final invalidConnectionPaint = Paint()
      ..color = Colors.red.withOpacity(0.7)
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Draw hint path
    if (showHint) {
      for (final connection in connections) {
        final start = constellation[connection[0]];
        final end = constellation[connection[1]];
        canvas.drawLine(
          _calculateStarPosition(start, size),
          _calculateStarPosition(end, size),
          hintPaint,
        );
      }
    }

    // Draw completed connections
    for (final indices in connections) {
      if (completedIndices.contains(indices[0]) && completedIndices.contains(indices[1])) {
        final start = constellation[indices[0]];
        final end = constellation[indices[1]];
        canvas.drawLine(
          _calculateStarPosition(start, size),
          _calculateStarPosition(end, size),
          linePaint,
        );
      }
    }

    // Current drag line
    if (currentDragPosition != null && !isComplete) {
      canvas.drawLine(
        Offset(
          constellation[currentIndex].dx * size.width,
          constellation[currentIndex].dy * size.height,
        ),
        currentDragPosition!,
        linePaint,
      );
    }

    // Draw player connections with validation coloring
    for (final connection in playerConnections) {
      final start = constellation[connection[0]];
      final end = constellation[connection[1]];

      final isValid = connections.any((conn) =>
          (conn[0] == connection[0] && conn[1] == connection[1]) ||
          (conn[0] == connection[1] && conn[1] == connection[0]));

      canvas.drawLine(
        _calculateStarPosition(start, size),
        _calculateStarPosition(end, size),
        isValid ? validConnectionPaint : invalidConnectionPaint,
      );
    }

    // Draw stars
    for (int i = 0; i < constellation.length; i++) {
      final position = constellation[i];
      final isActive = i == currentIndex && !isComplete;
      final isCompleted = completedIndices.contains(i) || isComplete;

      // Skip decoy stars if path clear is active
      if (showPathClear && !connections.any((conn) => conn.contains(i))) {
        continue;
      }

      final glowRadius = isActive ? starRadius * 3 : starRadius * 2;
      canvas.drawCircle(
        _calculateStarPosition(position, size),
        glowRadius,
        Paint()
          ..color = isActive
              ? Colors.blue.withOpacity(0.3)
              : isCompleted
                  ? Colors.green.withOpacity(0.15)
                  : Colors.white.withOpacity(0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      if (isActive || isCompleted) {
        canvas.drawCircle(
          Offset(position.dx * size.width, position.dy * size.height),
          starRadius * 1.5,
          Paint()
            ..color = isActive
                ? Colors.blue.withOpacity(0.5)
                : isCompleted
                    ? Colors.green.withOpacity(0.4)
                    : Colors.white.withOpacity(0.4)
            ..style = PaintingStyle.stroke
            ..strokeWidth = lineWidth * 0.5,
        );
      }

      canvas.drawCircle(
        _calculateStarPosition(position, size),
        isActive ? starRadius * 1.2 : starRadius,
        starPaint
          ..color = isActive
              ? Colors.blue
              : isCompleted
                  ? Colors.green
                  : Colors.white.withOpacity(0.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
