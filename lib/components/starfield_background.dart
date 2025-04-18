import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StarfieldBackground extends StatefulWidget {
  final Widget child;
  final int starCount;
  final Color starColor;
  final bool enableFallingStars;
  final double fallingStarInterval;

  const StarfieldBackground({
    super.key,
    required this.child,
    this.starCount = 50,
    this.starColor = Colors.white,
    this.enableFallingStars = true,
    this.fallingStarInterval = 10.0, // seconds
  });

  @override
  State<StarfieldBackground> createState() => _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends State<StarfieldBackground> with SingleTickerProviderStateMixin {
  late final List<BackgroundStar> _stars;
  late final Ticker _ticker;

  final List<FallingStarState> _fallingStars = [];
  double _lastFallingStarTime = 0;
  double _elapsedTime = 0;

  @override
  void initState() {
    super.initState();

    // Create stars once during initialization
    final random = math.Random();
    _stars = List.generate(
        widget.starCount,
        (_) => BackgroundStar(
              position: Offset(random.nextDouble(), random.nextDouble()),
              size: random.nextDouble() * 2 + 1,
              twinklePhase: random.nextDouble() * math.pi * 2,
              twinkleSpeed: 0.5 + random.nextDouble(),
            ));

    // Use a single ticker for all animations
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    _elapsedTime = elapsed.inMilliseconds / 1000.0;

    // Add falling stars periodically
    if (widget.enableFallingStars &&
        _elapsedTime - _lastFallingStarTime > widget.fallingStarInterval &&
        _fallingStars.isEmpty) {
      _addFallingStar();
      _lastFallingStarTime = _elapsedTime;
    }

    // Update falling stars
    for (int i = _fallingStars.length - 1; i >= 0; i--) {
      final star = _fallingStars[i];
      star.progress = ((_elapsedTime - star.startTime) / star.duration).clamp(0.0, 1.0);

      if (star.progress >= 1.0) {
        _fallingStars.removeAt(i);
      }
    }

    setState(() {
      // Trigger rebuild with new time
    });
  }

  void _addFallingStar() {
    final random = math.Random();

    final startX = random.nextDouble();

    // Create a consistent angle (20-30 degrees)
    final angle = (25 + random.nextDouble() * 10) * math.pi / 180;
    const distance = 1.5;

    final deltaX = distance * math.sin(angle);
    final deltaY = distance * math.cos(angle);

    final duration = 1.2 + random.nextDouble() * 0.3;

    _fallingStars.add(
      FallingStarState(
        startPosition: Offset(startX, -0.1),
        endPosition: Offset(startX - deltaX, deltaY),
        startTime: _elapsedTime,
        duration: duration,
        size: random.nextDouble() * 1.5 + 1.5,
        tailLength: random.nextDouble() * 0.15 + 0.1,
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background with stars - using RepaintBoundary to isolate painting
        RepaintBoundary(
          child: CustomPaint(
            size: MediaQuery.of(context).size,
            painter: StarfieldPainter(
              stars: _stars,
              currentTime: _elapsedTime,
              starColor: widget.starColor,
            ),
          ),
        ),

        // Falling stars - only when active
        if (_fallingStars.isNotEmpty)
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: FallingStarsPainter(
              stars: _fallingStars,
              starColor: widget.starColor,
            ),
          ),

        // Child content
        widget.child,
      ],
    );
  }
}

class BackgroundStar {
  final Offset position;
  final double size;
  final double twinklePhase;
  final double twinkleSpeed;

  BackgroundStar({
    required this.position,
    required this.size,
    required this.twinklePhase,
    required this.twinkleSpeed,
  });
}

class FallingStarState {
  final Offset startPosition;
  final Offset endPosition;
  final double startTime;
  final double duration;
  final double size;
  final double tailLength;
  double progress = 0.0;

  FallingStarState({
    required this.startPosition,
    required this.endPosition,
    required this.startTime,
    required this.duration,
    required this.size,
    required this.tailLength,
  });

  Offset get currentPosition {
    // Use easeIn curve for more natural motion
    final easeProgress = Curves.easeIn.transform(progress);
    return Offset(
      startPosition.dx + (endPosition.dx - startPosition.dx) * easeProgress,
      startPosition.dy + (endPosition.dy - startPosition.dy) * easeProgress,
    );
  }
}

class StarfieldPainter extends CustomPainter {
  final List<BackgroundStar> stars;
  final double currentTime;
  final Color starColor;

  StarfieldPainter({
    required this.stars,
    required this.currentTime,
    required this.starColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      // Calculate twinkle value using sine wave
      final twinkle = 0.3 + 0.7 * ((math.sin(currentTime * star.twinkleSpeed + star.twinklePhase) + 1) / 2);

      final paint = Paint()
        ..color = starColor.withOpacity(twinkle)
        ..style = PaintingStyle.fill;

      // Calculate screen position
      final position = Offset(
        star.position.dx * size.width,
        star.position.dy * size.height,
      );

      // Draw star with glow
      if (star.size > 1.5) {
        final glowPaint = Paint()
          ..color = starColor.withOpacity(0.1 * twinkle)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

        canvas.drawCircle(position, star.size * 2, glowPaint);
      }

      canvas.drawCircle(position, star.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarfieldPainter oldDelegate) => currentTime != oldDelegate.currentTime;
}

class FallingStarsPainter extends CustomPainter {
  final List<FallingStarState> stars;
  final Color starColor;

  FallingStarsPainter({
    required this.stars,
    required this.starColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final currentPos = star.currentPosition;
      final startX = currentPos.dx * size.width;
      final startY = currentPos.dy * size.height;

      final position = Offset(startX, startY);

      // Calculate tail angle based on movement direction
      final angle = math.pi / 7; // Approximately 25 degrees
      final tailLength = star.tailLength * size.height;
      final tailX = position.dx + tailLength * math.sin(angle);
      final tailY = position.dy - tailLength * math.cos(angle);

      // Draw the tail with gradient
      final path = Path()
        ..moveTo(position.dx, position.dy)
        ..lineTo(tailX, tailY);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final gradient = LinearGradient(
        colors: [
          starColor.withOpacity(0.8),
          starColor.withOpacity(0.0),
        ],
      );

      paint.shader = gradient.createShader(
        Rect.fromPoints(position, Offset(tailX, tailY)),
      );

      canvas.drawPath(path, paint);

      // Draw the star point
      final starPaint = Paint()
        ..color = starColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(position, star.size, starPaint);

      // Add a glow effect
      final glowPaint = Paint()
        ..color = starColor.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(position, star.size * 2, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant FallingStarsPainter oldDelegate) => true;
}
