import 'dart:math' as math;
import 'package:flutter/material.dart';

enum GameTheme {
  classic,
  nebula,
  aurora,
  deepSpace;

  String get displayName {
    switch (this) {
      case GameTheme.classic:
        return 'Classic';
      case GameTheme.nebula:
        return 'Nebula';
      case GameTheme.aurora:
        return 'Aurora';
      case GameTheme.deepSpace:
        return 'Deep Space';
    }
  }
}

class ThemeConfig {
  final Color backgroundColor;
  final Color starColor;
  final Color lineColor;
  final Color activeStarColor;
  final Color completedLineColor;
  final Color hintLineColor;
  final List<Color> backgroundGradient;
  final List<Color> starGlowColors;
  final bool enableParticles;
  final ParticleConfig particleConfig;
  final StarConfig starConfig;

  const ThemeConfig({
    required this.backgroundColor,
    required this.starColor,
    required this.lineColor,
    required this.activeStarColor,
    required this.completedLineColor,
    required this.hintLineColor,
    required this.backgroundGradient,
    required this.starGlowColors,
    this.enableParticles = true,
    this.particleConfig = const ParticleConfig(),
    this.starConfig = const StarConfig(),
  });

  static ThemeConfig forTheme(GameTheme theme) {
    switch (theme) {
      case GameTheme.classic:
        return ThemeConfig(
          backgroundColor: Colors.black,
          starColor: Colors.white,
          lineColor: Colors.white.withOpacity(0.7),
          activeStarColor: Colors.blue,
          completedLineColor: Colors.white,
          hintLineColor: Colors.white.withOpacity(0.3),
          backgroundGradient: [
            Colors.black,
            const Color(0xFF1A1B2E),
          ],
          starGlowColors: [Colors.white],
          particleConfig: const ParticleConfig(
            enabled: false,
          ),
          starConfig: const StarConfig(
            twinkleSpeed: 1.0,
            size: 1.0,
          ),
        );

      case GameTheme.nebula:
        return ThemeConfig(
          backgroundColor: const Color(0xFF120338),
          starColor: Colors.white,
          lineColor: Colors.purple.withOpacity(0.7),
          activeStarColor: Colors.pink,
          completedLineColor: Colors.purple,
          hintLineColor: Colors.purple.withOpacity(0.3),
          backgroundGradient: [
            const Color(0xFF120338),
            const Color(0xFF331B4D),
            const Color(0xFF4B1E47),
          ],
          starGlowColors: [
            Colors.purple,
            Colors.pink,
            Colors.blue,
          ],
          particleConfig: const ParticleConfig(
            enabled: true,
            colors: [
              Colors.purple,
              Colors.pink,
              Colors.blue,
            ],
            size: 2.0,
            speed: 0.8,
            density: 1.5,
          ),
          starConfig: const StarConfig(
            twinkleSpeed: 1.2,
            size: 1.2,
            glowIntensity: 1.5,
          ),
        );

      case GameTheme.aurora:
        return ThemeConfig(
          backgroundColor: const Color(0xFF042B1A),
          starColor: Colors.white,
          lineColor: Colors.green.withOpacity(0.7),
          activeStarColor: Colors.cyan,
          completedLineColor: Colors.green,
          hintLineColor: Colors.green.withOpacity(0.3),
          backgroundGradient: [
            const Color(0xFF042B1A),
            const Color(0xFF044B2E),
            const Color(0xFF1A6B3C),
          ],
          starGlowColors: [
            Colors.green,
            Colors.cyan,
            Colors.teal,
          ],
          particleConfig: const ParticleConfig(
            enabled: true,
            colors: [
              Colors.green,
              Colors.cyan,
              Colors.teal,
            ],
            size: 3.0,
            speed: 0.5,
            density: 1.0,
            waveEffect: true,
          ),
          starConfig: const StarConfig(
            twinkleSpeed: 0.8,
            size: 1.1,
            glowIntensity: 1.2,
          ),
        );

      case GameTheme.deepSpace:
        return ThemeConfig(
          backgroundColor: const Color(0xFF000819),
          starColor: Colors.white,
          lineColor: Colors.blue.withOpacity(0.7),
          activeStarColor: Colors.orange,
          completedLineColor: Colors.blue,
          hintLineColor: Colors.blue.withOpacity(0.3),
          backgroundGradient: [
            const Color(0xFF000819),
            const Color(0xFF001233),
            const Color(0xFF001845),
          ],
          starGlowColors: [
            Colors.blue,
            Colors.indigo,
            Colors.purple,
          ],
          particleConfig: const ParticleConfig(
            enabled: true,
            colors: [
              Colors.blue,
              Colors.indigo,
              Colors.purple,
            ],
            size: 1.5,
            speed: 0.3,
            density: 2.0,
            spiral: true,
          ),
          starConfig: const StarConfig(
            twinkleSpeed: 1.5,
            size: 0.8,
            glowIntensity: 2.0,
          ),
        );
    }
  }
}

/// Configuration for particle effects in the theme
class ParticleConfig {
  final bool enabled;
  final List<Color> colors;
  final double size;
  final double speed;
  final double density;
  final bool waveEffect;
  final bool spiral;

  const ParticleConfig({
    this.enabled = true,
    this.colors = const [Colors.white],
    this.size = 1.0,
    this.speed = 1.0,
    this.density = 1.0,
    this.waveEffect = false,
    this.spiral = false,
  });
}

/// Configuration for star appearance and behavior
class StarConfig {
  final double twinkleSpeed;
  final double size;
  final double glowIntensity;

  const StarConfig({
    this.twinkleSpeed = 1.0,
    this.size = 1.0,
    this.glowIntensity = 1.0,
  });
}

/// Custom painter for theme-specific background effects
class ThemeBackgroundPainter extends CustomPainter {
  final ThemeConfig theme;
  final Animation<double>? animation;

  ThemeBackgroundPainter({
    required this.theme,
    this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background gradient
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: theme.backgroundGradient,
    );

    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );

    if (theme.particleConfig.enabled) {
      _drawParticles(canvas, size);
    }
  }

  void _drawParticles(Canvas canvas, Size size) {
    final random = math.Random(42);
    final particleCount =
        (size.width * size.height / 10000 * theme.particleConfig.density)
            .round();

    for (var i = 0; i < particleCount; i++) {
      final color = theme.particleConfig
          .colors[random.nextInt(theme.particleConfig.colors.length)];
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final particleSize = random.nextDouble() * theme.particleConfig.size;

      if (theme.particleConfig.waveEffect && animation != null) {
        final wave = math.sin(animation!.value * 2 * math.pi + x / 50);
        final adjustedY = y + wave * 10;
        _drawParticle(canvas, Offset(x, adjustedY), particleSize, color);
      } else if (theme.particleConfig.spiral && animation != null) {
        final angle = (x + y) / 100 + animation!.value * 2 * math.pi;
        final radius = math.sqrt(x * x + y * y) / 10;
        final spiralX = x + math.cos(angle) * radius;
        final spiralY = y + math.sin(angle) * radius;
        _drawParticle(canvas, Offset(spiralX, spiralY), particleSize, color);
      } else {
        _drawParticle(canvas, Offset(x, y), particleSize, color);
      }
    }
  }

  void _drawParticle(Canvas canvas, Offset position, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawCircle(position, size, paint);
  }

  @override
  bool shouldRepaint(covariant ThemeBackgroundPainter oldDelegate) {
    return oldDelegate.theme != theme || oldDelegate.animation != animation;
  }
}
