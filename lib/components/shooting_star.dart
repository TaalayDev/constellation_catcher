import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShootingStar {
  final Offset startPosition;
  final Offset endPosition;
  final double speed;
  final double size;
  final int bonusPoints;
  bool isCaught = false;
  bool isActive = true;

  ShootingStar({
    required this.startPosition,
    required this.endPosition,
    required this.speed,
    required this.size,
    required this.bonusPoints,
  });
}

class ShootingStarManager {
  final List<ShootingStar> stars = [];
  final random = math.Random();
  Timer? _spawnTimer;
  final Function(int) onScoreBonus;

  ShootingStarManager({required this.onScoreBonus});

  void startSpawning() {
    _spawnTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (stars.length < 3 && math.Random().nextDouble() < 0.6) {
        // 60% chance every 10 seconds
        _spawnShootingStar();
      }
    });
  }

  void stopSpawning() {
    _spawnTimer?.cancel();
    _spawnTimer = null;
  }

  void _spawnShootingStar() {
    // Create a shooting star with a random trajectory
    final startX = math.Random().nextDouble();
    final endX = startX - 0.3 - math.Random().nextDouble() * 0.5;
    final endY = 0.8 + math.Random().nextDouble() * 0.2;

    final star = ShootingStar(
      startPosition: Offset(startX, -0.1),
      endPosition: Offset(endX, endY),
      speed: 2.0 + math.Random().nextDouble() * 3.0,
      size: 3.0 + math.Random().nextDouble() * 2.0,
      bonusPoints: 50 + math.Random().nextInt(50),
    );

    stars.add(star);

    // Auto-remove after 4 seconds if not caught
    Future.delayed(const Duration(seconds: 4), () {
      stars.remove(star);
    });
  }

  bool tryToCatch(Offset position, Size screenSize) {
    for (final star in stars) {
      if (star.isActive && !star.isCaught) {
        // Check if tap is close to the star (within 50 logical pixels)
        final screenPos = Offset(
            star.startPosition.dx +
                (star.endPosition.dx - star.startPosition.dx) * 0.5,
            star.startPosition.dy +
                (star.endPosition.dy - star.startPosition.dy) * 0.5);

        final starPixelPos = Offset(
            screenPos.dx * screenSize.width, screenPos.dy * screenSize.height);

        if ((position - starPixelPos).distance < 50) {
          star.isCaught = true;
          onScoreBonus(star.bonusPoints);

          // Remove after showing caught animation
          Future.delayed(const Duration(milliseconds: 500), () {
            stars.remove(star);
          });

          return true;
        }
      }
    }
    return false;
  }

  void dispose() {
    _spawnTimer?.cancel();
    stars.clear();
  }
}

class ShootingStarPainter extends CustomPainter {
  final List<ShootingStar> stars;
  final double animationValue;

  ShootingStarPainter({
    required this.stars,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      if (!star.isActive) continue;

      final progress =
          star.isCaught ? 1.0 : (animationValue * star.speed).clamp(0.0, 1.0);

      // Calculate current position
      final currentX = star.startPosition.dx +
          (star.endPosition.dx - star.startPosition.dx) * progress;
      final currentY = star.startPosition.dy +
          (star.endPosition.dy - star.startPosition.dy) * progress;

      final currentPos = Offset(currentX * size.width, currentY * size.height);

      // Draw star trail
      final tailPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.8),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(
          Rect.fromPoints(
            currentPos,
            Offset(
              (currentX - 0.1) * size.width,
              (currentY - 0.1) * size.height,
            ),
          ),
        )
        ..strokeWidth = star.size
        ..style = PaintingStyle.stroke;

      final path = Path()
        ..moveTo(currentPos.dx, currentPos.dy)
        ..lineTo(
          (currentX - 0.1) * size.width,
          (currentY - 0.1) * size.height,
        );

      canvas.drawPath(path, tailPaint);

      // Draw the star
      final starPaint = Paint()
        ..color = star.isCaught ? Colors.amber : Colors.white
        ..style = PaintingStyle.fill;

      // If caught, make it pulse
      final starSize = star.isCaught
          ? star.size * (1.0 + math.sin(animationValue * 10) * 0.5)
          : star.size;

      canvas.drawCircle(currentPos, starSize, starPaint);

      // Add glow effect
      final glowPaint = Paint()
        ..color = (star.isCaught ? Colors.amber : Colors.white).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(currentPos, starSize * 2, glowPaint);

      // Show bonus points when caught
      if (star.isCaught) {
        const textStyle = TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Colors.black,
              offset: Offset(1, 1),
            ),
          ],
        );

        final textSpan = TextSpan(
          text: '+${star.bonusPoints}',
          style: textStyle,
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        // Position above the star, floating upward as it fades
        final fadeProgress = math.min(1.0, (animationValue * 2) % 1.0);
        textPainter.paint(
          canvas,
          Offset(
            currentPos.dx - textPainter.width / 2,
            currentPos.dy - 30 - fadeProgress * 20,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ShootingStarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.stars != stars;
  }
}
