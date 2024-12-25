import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/database_provider.dart';
import '../components/background_gradient.dart';
import '../config/sound_controller.dart';
import 'settings_screen.dart';

class MenuScreen extends StatefulHookConsumerWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _backgroundController;
  final List<MenuStar> _stars = [];

  final List<FallingStar> _fallingStars = [];
  late final Timer _fallingStarTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    SoundController().playBackgroundMusic(
      'game',
      fadeInDuration: const Duration(seconds: 8),
    );

    for (int i = 0; i < 100; i++) {
      _stars.add(MenuStar(
        position: Offset(
          math.Random().nextDouble(),
          math.Random().nextDouble(),
        ),
        size: math.Random().nextDouble() * 3 + 1,
        twinkleSpeed: math.Random().nextDouble() * 2 + 0.5,
      ));
    }

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _startFallingStarsTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _stopFallingStarsTimer();
    } else if (state == AppLifecycleState.resumed) {
      _startFallingStarsTimer();
    }
  }

  void _startFallingStarsTimer() {
    _fallingStarTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _addFallingStar();
    });
  }

  void _stopFallingStarsTimer() {
    _fallingStarTimer.cancel();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _backgroundController.dispose();
    _fallingStarTimer.cancel();
    for (var star in _fallingStars) {
      star.controller.dispose();
    }
    super.dispose();
  }

  void _addFallingStar() {
    if (!mounted) return;

    final random = math.Random();

    final startX = random.nextDouble();

    // Create a more consistent angle (20-30 degrees)
    final angle = (25 + random.nextDouble() * 10) * math.pi / 180;
    const distance = 1.5;

    final deltaX = distance * math.sin(angle);
    final deltaY = distance * math.cos(angle);

    final duration = 1200 + random.nextInt(300);

    final controller = AnimationController(
      duration: Duration(milliseconds: duration),
      vsync: this,
    );

    final fallingStar = FallingStar(
      startPosition: Offset(startX, -0.1),
      endPosition: Offset(startX - deltaX, deltaY),
      controller: controller,
      size: random.nextDouble() * 1.5 + 1.5,
      tailLength: random.nextDouble() * 0.15 + 0.1,
    );

    setState(() {
      _fallingStars.add(fallingStar);
    });

    controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _fallingStars.remove(fallingStar);
        });
        controller.dispose();
      }
    });
  }

  Widget _buildMenu(BuildContext context, BoxConstraints constraints) {
    // Determine device type based on width
    final deviceWidth = constraints.maxWidth;
    final isDesktop = deviceWidth > 1200;
    final isTablet = deviceWidth > 600 && deviceWidth <= 1200;
    final isPhone = deviceWidth <= 600;

    final horizontalPadding = isDesktop
        ? deviceWidth * 0.2
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
                    ? 80
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
                    () => Navigator.pushNamed(context, '/game'),
                    buttonTextSize,
                    isDesktop,
                  ),
                  SizedBox(height: isDesktop ? 24 : 16),
                  _buildMenuButton(
                    'Level Select',
                    Icons.grid_view_rounded,
                    () => Navigator.pushNamed(context, '/level-select'),
                    buttonTextSize,
                    isDesktop,
                  ),
                  SizedBox(height: isDesktop ? 24 : 16),
                  _buildMenuButton(
                    'Achievements',
                    Icons.emoji_events_rounded,
                    () => Navigator.pushNamed(context, '/achievements'),
                    buttonTextSize,
                    isDesktop,
                  ),
                  SizedBox(height: isDesktop ? 24 : 16),
                  _buildMenuButton(
                    'Settings',
                    Icons.settings_rounded,
                    () => SettingsDialog.show(context),
                    buttonTextSize,
                    isDesktop,
                  ),
                ],
              ),

              const Spacer(),

              // High score section with responsive sizing
              Container(
                padding: EdgeInsets.all(isDesktop
                    ? 32
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
                      ? 48
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
    return Scaffold(
      body: BackgroundGradient(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Background stars with parallax effect
                ...List.generate(_stars.length, (index) {
                  final star = _stars[index];
                  return MenuStarWidget(
                    star: star,
                    constraints: constraints,
                  );
                }),

                // Falling stars
                ...List.generate(_fallingStars.length, (index) {
                  final star = _fallingStars[index];
                  return FallingStarWidget(
                    star: star,
                    constraints: constraints,
                  );
                }),

                // Main menu content
                SafeArea(child: _buildMenu(context, constraints)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MenuStar {
  final Offset position;
  final double size;
  final double twinkleSpeed;

  MenuStar({
    required this.position,
    required this.size,
    required this.twinkleSpeed,
  });
}

class MenuStarWidget extends StatefulWidget {
  final MenuStar star;
  final BoxConstraints constraints;

  const MenuStarWidget({
    super.key,
    required this.star,
    required this.constraints,
  });

  @override
  State<MenuStarWidget> createState() => _MenuStarWidgetState();
}

class _MenuStarWidgetState extends State<MenuStarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(
        milliseconds: (1000 * widget.star.twinkleSpeed).round(),
      ),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = widget.constraints.maxWidth > 600;
    final starSize = widget.star.size * (isLargeScreen ? 1.5 : 1.0);

    return Positioned(
      left: widget.star.position.dx * widget.constraints.maxWidth,
      top: widget.star.position.dy * widget.constraints.maxHeight,
      child: FadeTransition(
        opacity: Tween(begin: 0.3, end: 1.0).animate(_controller),
        child: Container(
          width: starSize,
          height: starSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: starSize,
                spreadRadius: starSize / 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FallingStar {
  final Offset startPosition;
  final Offset endPosition;
  final AnimationController controller;
  final double size;
  final double tailLength;

  FallingStar({
    required this.startPosition,
    required this.endPosition,
    required this.controller,
    required this.size,
    required this.tailLength,
  });

  Offset get currentPosition {
    // Use a custom curve for more natural motion
    const curve = Curves.easeIn;
    final progress = curve.transform(controller.value);
    return Offset(
      startPosition.dx + (endPosition.dx - startPosition.dx) * progress,
      startPosition.dy + (endPosition.dy - startPosition.dy) * progress,
    );
  }
}

class FallingStarWidget extends StatelessWidget {
  final FallingStar star;
  final BoxConstraints constraints;

  const FallingStarWidget({
    super.key,
    required this.star,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: star.controller,
      builder: (context, child) {
        final currentPos = star.currentPosition;
        final startX = currentPos.dx * constraints.maxWidth;
        final startY = currentPos.dy * constraints.maxHeight;

        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: FallingStarPainter(
            position: Offset(startX, startY),
            size: star.size,
            tailLength: star.tailLength * constraints.maxHeight,
            progress: star.controller.value,
          ),
        );
      },
    );
  }
}

class FallingStarPainter extends CustomPainter {
  final Offset position;
  final double size;
  final double tailLength;
  final double progress;

  FallingStarPainter({
    required this.position,
    required this.size,
    required this.tailLength,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Calculate tail angle based on movement direction
    final angle = math.pi / 7; // Approximately 25 degrees
    final tailX = position.dx + tailLength * math.sin(angle);
    final tailY = position.dy - tailLength * math.cos(angle);

    // Draw the tail with gradient
    final path = Path()
      ..moveTo(position.dx, position.dy)
      ..lineTo(tailX, tailY);

    final gradient = LinearGradient(
      colors: [
        Colors.white.withOpacity(0.8),
        Colors.white.withOpacity(0.0),
      ],
    );

    paint.shader = gradient.createShader(
      Rect.fromPoints(
        position,
        Offset(tailX, tailY),
      ),
    );

    canvas.drawPath(path, paint);

    // Draw the star point
    final starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, this.size, starPaint);

    // Add a glow effect
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawCircle(position, this.size * 2, glowPaint);
  }

  @override
  bool shouldRepaint(covariant FallingStarPainter oldDelegate) {
    return position != oldDelegate.position ||
        size != oldDelegate.size ||
        tailLength != oldDelegate.tailLength ||
        progress != oldDelegate.progress;
  }
}
