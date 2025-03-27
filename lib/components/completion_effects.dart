import 'dart:math' as math;
import 'package:flutter/material.dart';

class CompletionEffects {
  final List<ConstellationParticle> particles = [];
  final random = math.Random();
  final Offset center;
  final double size;

  CompletionEffects({
    required this.center,
    required this.size,
  }) {
    _generateParticles();
  }

  void _generateParticles() {
    // Create particles in a starburst pattern
    for (int i = 0; i < 60; i++) {
      final angle = math.Random().nextDouble() * math.pi * 2;
      final speed = 0.5 + math.Random().nextDouble() * 1.5;
      final distance = 0.2 + math.Random().nextDouble() * 0.8;

      particles.add(ConstellationParticle(
        startPosition: center,
        velocity: Offset(
          math.cos(angle) * speed,
          math.sin(angle) * speed,
        ),
        maxDistance: distance * size,
        color: _getRandomColor(),
        size: 1.0 + math.Random().nextDouble() * 3.0,
      ));
    }
  }

  Color _getRandomColor() {
    final colors = [
      Colors.white,
      Colors.blue.shade200,
      Colors.yellow.shade200,
      Colors.amber,
      Colors.lightBlue.shade200,
    ];

    return colors[math.Random().nextInt(colors.length)];
  }

  bool updateParticles(double dt) {
    bool anyActive = false;

    for (final particle in particles) {
      if (particle.update(dt)) {
        anyActive = true;
      }
    }

    return anyActive;
  }
}

class ConstellationParticle {
  final Offset startPosition;
  final Offset velocity;
  final double maxDistance;
  final Color color;
  final double size;

  Offset currentPosition;
  double distanceTraveled = 0;
  double opacity = 1.0;
  bool isActive = true;

  ConstellationParticle({
    required this.startPosition,
    required this.velocity,
    required this.maxDistance,
    required this.color,
    required this.size,
  }) : currentPosition = startPosition;

  bool update(double dt) {
    if (!isActive) return false;

    // Update position
    final displacement = Offset(velocity.dx * dt, velocity.dy * dt);
    currentPosition = currentPosition + displacement;
    distanceTraveled += displacement.distance;

    // Update opacity
    final progress = distanceTraveled / maxDistance;
    opacity = 1.0 - progress;

    // Check if particle should be deactivated
    if (distanceTraveled >= maxDistance || opacity <= 0) {
      isActive = false;
    }

    return isActive;
  }
}

class CompletionEffectsPainter extends CustomPainter {
  final CompletionEffects effects;

  CompletionEffectsPainter({required this.effects});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in effects.particles) {
      if (!particle.isActive) continue;

      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(particle.currentPosition, particle.size, paint);

      // Add glow effect for larger particles
      if (particle.size > 2.0) {
        final glowPaint = Paint()
          ..color = particle.color.withOpacity(particle.opacity * 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

        canvas.drawCircle(
            particle.currentPosition, particle.size * 2, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CompletionEffectsPainter oldDelegate) {
    return true; // Always repaint as particles are moving
  }
}

class StarConnectionEffect {
  final Offset startPosition;
  final Offset endPosition;
  final Color color;
  double progress = 0.0;

  StarConnectionEffect({
    required this.startPosition,
    required this.endPosition,
    required this.color,
  });

  bool update(double dt) {
    progress += dt * 3.0; // Adjust speed as needed
    return progress < 1.0;
  }

  Offset get currentEndPosition {
    return Offset(
        startPosition.dx + (endPosition.dx - startPosition.dx) * progress,
        startPosition.dy + (endPosition.dy - startPosition.dy) * progress);
  }
}

class ConnectionEffectsPainter extends CustomPainter {
  final List<StarConnectionEffect> connections;

  ConnectionEffectsPainter({required this.connections});

  @override
  void paint(Canvas canvas, Size size) {
    for (final connection in connections) {
      // Draw pulse wave along the connection line
      final path = Path();
      final start = connection.startPosition;
      final current = connection.currentEndPosition;

      path.moveTo(start.dx, start.dy);
      path.lineTo(current.dx, current.dy);

      final linePaint = Paint()
        ..color = connection.color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, linePaint);

      // Pulse effect
      final waveCount = 3;
      for (int i = 0; i < waveCount; i++) {
        final waveProgress = (connection.progress - (i / waveCount)) % 1.0;

        if (waveProgress > 0 && waveProgress < 1) {
          final wavePos = Offset(
              start.dx + (current.dx - start.dx) * waveProgress,
              start.dy + (current.dy - start.dy) * waveProgress);

          final wavePaint = Paint()
            ..color = connection.color.withOpacity(0.7 * (1 - waveProgress))
            ..style = PaintingStyle.fill;

          canvas.drawCircle(wavePos, 6 * (1 - waveProgress), wavePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ConnectionEffectsPainter oldDelegate) {
    return true; // Always repaint as connections are animating
  }
}
