import 'dart:async';
import 'dart:math' as math;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/background_gradient.dart';
import '../components/completion_effects.dart';
import '../components/shooting_star.dart';
import '../core/config/game_config.dart';
import '../components/dialogs/constellation_complete_dialog.dart';
import '../core/sound_controller.dart';
import '../data/constellation_data.dart';
import '../models/constellation_level.dart';
import '../provider/database_provider.dart';
import '../data/local_storage.dart';

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

class _GameScreenState extends ConsumerState<GameScreen>
    with TickerProviderStateMixin {
  late List<AnimatedGameStar> _backgroundStars;
  int _currentStarIndex = -1;
  int _currentLevel = 0;
  Offset? _currentDragPosition;
  List<int> _completedIndices = [];
  bool _isDragging = false;
  bool _showHint = false;
  int _score = 0;
  bool _levelComplete = false;

  // Star animation controllers

  int _mistakes = 0;
  late int _remainingTime = _isHardMode ? 30 : 60;
  int _comboMultiplier = 1;
  int _consecutiveCorrect = 0;
  bool _powerUpActive = false;
  Timer? _gameTimer;
  bool _isTimeFreeze = false;

  // Power-up states
  late bool _hasTimeFreeze = !_isHardMode;
  bool _hasStarReveal = false;
  late bool _hasPathClear = !_isHardMode;

  late final AnimationController _hintController;
  late final AnimationController _powerUpController;
  late final AnimationController _comboController;
  final List<AnimationController> _starAnimationControllers = [];

  List<List<int>> _playerConnections = [];
  bool _isValidating = false;

  List<ConstellationLevel> get _levels => ConstellationDataService.levels;
  ConstellationLevel get level => _levels[_currentLevel];
  bool get _isClosedLoop => level.isClosedLoop;

  late final bool _isHardMode = widget.mode == 'Hard';

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.levelIndex;
    _initializeGame();
    _initializeAnimations();
    _startGameTimer();
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
      _remainingTime = _isHardMode ? 30 : 60;
      _comboMultiplier = 1;
      _consecutiveCorrect = 0;
      _levelComplete = false;
      _hasTimeFreeze = !_isHardMode;
      _hasPathClear = !_isHardMode;
      _playerConnections = [];
    });
  }

  void _startGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isTimeFreeze) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            _endGame(completed: false);
          }
        });
      }
    });
  }

  void _activateTimeFreeze() {
    if (!_hasTimeFreeze) return;

    setState(() {
      _hasTimeFreeze = false;
      _gameTimer?.cancel();
      _powerUpController.forward(from: 0);
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      _startGameTimer();
    });
  }

  void _activateStarReveal() {
    if (!_hasStarReveal) return;

    setState(() {
      _hasStarReveal = false;
      _powerUpActive = true;
      _powerUpController.forward(from: 0);
      _showHint = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _powerUpActive = false;
        _showHint = false;
      });
    });
  }

  void _activatePathClear() {
    if (!_hasPathClear) return;

    setState(() {
      _hasPathClear = false;
      _powerUpController.forward(from: 0);
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
    });
  }

  void _endGame({required bool completed}) {
    _gameTimer?.cancel();

    final timeBonus = _remainingTime * 10;
    final finalScore = _score + timeBonus;

    setState(() {
      _levelComplete = completed;
      _score = finalScore;
    });

    if (completed) {
      LocalStorage().completedLevels = [
        ...LocalStorage().completedLevels,
        level.name,
      ];
      FirebaseAnalytics.instance.logEvent(
        name: 'level_completed',
        parameters: {
          'level': level.name,
          'score': finalScore,
          'time_taken': GameConfig.lineDrawTimeout.inSeconds - _remainingTime,
        },
      );
      _showCompletionDialog();
    }
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _powerUpController.dispose();
    _comboController.dispose();

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
      return EdgeInsets.symmetric(horizontal: size.width * 0.2);
    } else if (size.width > 600) {
      return EdgeInsets.symmetric(horizontal: size.width * 0.1);
    }
    return const EdgeInsets.symmetric(horizontal: 16);
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
                  IconButton(
                    icon: const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() => _showHint = true);
                      _hintController.forward(from: 0).then((_) {
                        setState(() => _showHint = false);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          Padding(
            padding: _getResponsivePadding(context),
            child:
                _levelComplete ? const SizedBox() : _buildLevelInfoUI(context),
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
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: available
                  ? Colors.white.withOpacity(0.2)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: available ? Colors.white : Colors.white38,
              size: 24,
            ),
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

  void _resetLevel() {
    setState(() {
      _playerConnections.clear();
      _currentStarIndex = -1;
      _currentDragPosition = null;
      _isDragging = false;
      _isValidating = false;
      _levelComplete = false;
      _remainingTime = _isHardMode ? 30 : 60;
      _comboMultiplier = 1;
      _consecutiveCorrect = 0;
    });

    _startGameTimer();
  }

  void _startNextLevel() {
    setState(() {
      _currentLevel++;
      _resetLevel();
    });
  }

  void _showCompletionDialog() {
    final timeBonus = _remainingTime * 10;
    final mistakePenalty = _mistakes * 50;
    final finalScore = _score + timeBonus - mistakePenalty;

    final timeTaken = Duration(
      seconds: GameConfig.lineDrawTimeout.inSeconds - _remainingTime,
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

  Future<void> _saveProgress(int finalScore) async {
    final db = ref.read(databaseProvider);

    // Update stats
    await db.incrementStat('totalConstellationsCompleted');

    // Update high score if necessary
    final currentHighScore = await db.getStat('highScore');
    if (finalScore > currentHighScore) {
      await db.setStat('highScore', finalScore);
    }

    // Update achievements
    if (_mistakes == 0) {
      await db.updateAchievementProgress('Perfect Draw', 1);
    }

    final timeTaken = GameConfig.lineDrawTimeout.inSeconds - _remainingTime;
    if (timeTaken <= 30) {
      await db.updateAchievementProgress('Speed Demon', 1);
    }

    await db.updateAchievementProgress(
      'Star Collector',
      _completedIndices.length,
    );
    await db.updateAchievementProgress('Constellation Master', 1);
  }

  Size _getPainterSize(BuildContext context) {
    final padding = _getResponsivePadding(context);
    final width = MediaQuery.of(context).size.width - padding.horizontal;
    final height = MediaQuery.of(context).size.height - padding.vertical;
    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BackgroundGradient(
        child: Stack(
          children: [
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: AnimatedBackgroundStarsPainter(
                stars: _backgroundStars,
                starRadius: _getStarRadius(context),
              ),
            ),
            Center(
              child: LayoutBuilder(builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth > 600;
                final size = Size(
                  constraints.maxWidth,
                  !isWideScreen
                      ? constraints.maxHeight * 0.6
                      : constraints.maxHeight,
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
                    ),
                  ),
                );
              }),
            ),

            _buildGameUI(context),

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
                      onTap: _activateTimeFreeze,
                      tooltip: 'Freeze Time (5s)',
                    ),
                    const SizedBox(height: 8),
                    _buildPowerUpButton(
                      icon: Icons.visibility,
                      available: _hasStarReveal,
                      onTap: _activateStarReveal,
                      tooltip: 'Reveal Path (3s)',
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
                    _buildStat('Mistakes', '$_mistakes/3'),
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
    if (_levelComplete) return;

    final starRadius = _getStarRadius(context);

    for (int i = 0; i < level.starPositions.length; i++) {
      final starPos = level.starPositions[i];
      final targetPixelPosition = _calculateStarPosition(starPos, screenSize);

      if ((targetPixelPosition - details.localPosition).distance < starRadius) {
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
    if (!_isDragging || _levelComplete) return;

    setState(() {
      _currentDragPosition = details.localPosition;
    });

    final starRadius = _getStarRadius(context);

    for (int i = 0; i < level.starPositions.length; i++) {
      if (i == _currentStarIndex) continue;

      final targetPos = level.starPositions[i];
      final targetPixelPosition = _calculateStarPosition(targetPos, screenSize);

      if ((targetPixelPosition - details.localPosition).distance < starRadius) {
        _playerConnections.add([_currentStarIndex, i]);

        setState(() {
          _currentStarIndex = i;
        });

        HapticFeedback.lightImpact();
        SoundController().playSound('connect');

        if (_isValidConnection(_currentStarIndex, i)) {
          _consecutiveCorrect++;
          if (_consecutiveCorrect >= 3) {
            _comboMultiplier = math.min(4, _consecutiveCorrect ~/ 3);

            // Show combo animation
            _comboController.forward(from: 0);
          }
        }
        return;
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging) return;

    setState(() {
      _isDragging = false;
      _currentDragPosition = null;
    });

    if (_playerConnections.length >= level.connections.length) {
      _validatePattern();
    }
  }

  void _validatePattern() {
    setState(() {
      _isValidating = true;
    });

    final isCorrectPattern = _playerConnections.every((connection) {
      return _isValidConnection(connection[0], connection[1]);
    });

    if (isCorrectPattern) {
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
    setState(() {
      _levelComplete = true;
      _score += 100 * _comboMultiplier;
      _consecutiveCorrect++;

      if (_consecutiveCorrect >= 3) {
        _comboMultiplier = math.min(4, _consecutiveCorrect ~/ 3);
      }
    });

    HapticFeedback.lightImpact();
    SoundController().playSound('success');

    _endGame(completed: true);
  }

  void _handleIncorrectPattern() {
    setState(() {
      _mistakes++;
      _consecutiveCorrect = 0;
      _comboMultiplier = 1;
      _playerConnections.clear();
    });

    HapticFeedback.heavyImpact();

    if (_mistakes >= 3) {
      _endGame(completed: false);
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
      if (completedIndices.contains(indices[0]) &&
          completedIndices.contains(indices[1])) {
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

    for (final connection in playerConnections) {
      final start = constellation[connection[0]];
      final end = constellation[connection[1]];
      canvas.drawLine(
        _calculateStarPosition(start, size),
        _calculateStarPosition(end, size),
        linePaint,
      );
    }

    // Draw stars
    for (int i = 0; i < constellation.length; i++) {
      final position = constellation[i];
      final isActive = i == currentIndex && !isComplete;
      final isCompleted = i < currentIndex || isComplete;

      final glowRadius = isActive ? starRadius * 3 : starRadius * 2;
      canvas.drawCircle(
        _calculateStarPosition(position, size),
        glowRadius,
        Paint()
          ..color = isActive
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      if (isActive || isCompleted) {
        canvas.drawCircle(
          Offset(position.dx * size.width, position.dy * size.height),
          starRadius * 1.5,
          Paint()
            ..color = Colors.white.withOpacity(0.4)
            ..style = PaintingStyle.stroke
            ..strokeWidth = lineWidth * 0.5,
        );
      }

      canvas.drawCircle(
        _calculateStarPosition(position, size),
        isActive ? starRadius * 1.2 : starRadius,
        starPaint
          ..color = isCompleted || isActive
              ? Colors.white
              : Colors.white.withOpacity(0.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
