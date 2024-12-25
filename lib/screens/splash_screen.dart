import 'dart:math' as math;
import 'package:constellation_catcher/components/background_gradient.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _scaleController;
  late final AnimationController _fadeController;
  final List<Star> _stars = [];

  @override
  void initState() {
    super.initState();

    // Generate random stars
    for (int i = 0; i < 50; i++) {
      _stars.add(Star(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        size: math.Random().nextDouble() * 3 + 1,
        twinkleSpeed: math.Random().nextDouble() * 2 + 0.5,
      ));
    }

    // Rotation animation for constellation
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Scale animation for title
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation for subtitle
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Start animations sequence
    _scaleController.forward().then((_) {
      _fadeController.forward().then((_) {
        // Navigate to game screen after animations
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/menu');
        });
      });
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BackgroundGradient(
        child: Stack(
          children: [
            // Animated stars background
            ...List.generate(_stars.length, (index) {
              final star = _stars[index];
              return TwinklingStar(star: star);
            }),

            // Rotating constellation
            Center(
              child: RotationTransition(
                turns: _rotationController,
                child: CustomPaint(
                  size: const Size(200, 200),
                  painter: ConstellationPainter(),
                ),
              ),
            ),

            // Game title with scale animation
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _scaleController,
                      curve: Curves.easeOutBack,
                    ),
                    child: const Text(
                      'Constellation\nCatcher',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _fadeController,
                    child: const Text(
                      'Connect the Stars',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        letterSpacing: 4,
                      ),
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

class Star {
  final double x;
  final double y;
  final double size;
  final double twinkleSpeed;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.twinkleSpeed,
  });
}

class TwinklingStar extends StatefulWidget {
  final Star star;

  const TwinklingStar({
    super.key,
    required this.star,
  });

  @override
  State<TwinklingStar> createState() => _TwinklingStarState();
}

class _TwinklingStarState extends State<TwinklingStar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration:
          Duration(milliseconds: (1000 * widget.star.twinkleSpeed).round()),
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
    return Positioned(
      left: widget.star.x * MediaQuery.of(context).size.width,
      top: widget.star.y * MediaQuery.of(context).size.height,
      child: FadeTransition(
        opacity: Tween(begin: 0.3, end: 1.0).animate(_controller),
        child: Container(
          width: widget.star.size,
          height: widget.star.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: widget.star.size,
                spreadRadius: widget.star.size / 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConstellationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Define constellation points
    final points = [
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.7, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.3, size.height * 0.4),
    ];

    // Draw lines connecting the points
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    canvas.drawPath(path, paint);

    // Draw points
    for (var point in points) {
      canvas.drawCircle(point, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
