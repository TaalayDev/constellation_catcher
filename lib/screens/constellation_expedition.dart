import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forge2d/forge2d.dart' hide Transform;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../core/game_theme.dart';
import '../core/sound_controller.dart';
import '../data/constellation_data.dart';
import '../components/background_gradient.dart';
import '../provider/theme_provider.dart';

// Game physics world scale
const double worldScale = 10.0;

class ExpeditionGameScreen extends ConsumerStatefulWidget {
  const ExpeditionGameScreen({super.key});

  @override
  ConsumerState<ExpeditionGameScreen> createState() =>
      _ExpeditionGameScreenState();
}

class _ExpeditionGameScreenState extends ConsumerState<ExpeditionGameScreen>
    with TickerProviderStateMixin {
  // Forge2D physics world
  late World _world;

  // Game state
  late SpaceshipBody _spaceship;
  List<StarBody> _stars = [];
  List<GravityFieldBody> _gravityFields = [];
  List<AnomalyBody> _anomalies = [];
  List<ConstellationZone> _constellations = [];

  // Discovered constellations
  Set<String> _discoveredConstellations = {};

  // Current level/sector
  int _currentSector = 0;
  String _currentObjective = "Discover the Triangulum constellation";

  // Game stats
  int _fuelLevel = 100;
  int _score = 0;

  // Control state
  bool _thrusterActive = false;
  double _rotationDirection = 0;

  // Animation controllers
  late AnimationController _gameLoopController;
  late AnimationController _thrusterAnimationController;
  late AnimationController _starTwinkleController;

  // Touch position for mobile controls
  Offset? _touchPosition;

  // Viewport size and position
  double _viewportZoom = 1.0;
  Offset _viewportPosition = Offset.zero;

  // Level completion
  bool _levelCompleted = false;
  String? _completedConstellation;

  @override
  void initState() {
    super.initState();

    // Create physics world with light gravity
    _world = World(Vector2(0, 0.2));

    // Initialize game loop animation controller
    _gameLoopController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Initialize thruster animation controller
    _thrusterAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Initialize star twinkle animation controller
    _starTwinkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Set up the first level
    _setupLevel();

    // Start game loop
    _gameLoopController.addListener(_gameLoop);

    // Play background music
    SoundController().playBackgroundMusic('game');
  }

  @override
  void dispose() {
    _gameLoopController.dispose();
    _thrusterAnimationController.dispose();
    _starTwinkleController.dispose();
    super.dispose();
  }

  // Main game loop
  void _gameLoop() {
    if (_levelCompleted) return;

    // Update physics world
    //_world.step(const Duration(milliseconds: 16).inSeconds.toDouble(), 6, 2);

    // Update spaceship controls
    _updateSpaceshipControls();

    // Check for collisions
    _checkCollisions();

    // Update fuel
    if (_thrusterActive && _fuelLevel > 0) {
      setState(() {
        _fuelLevel = math.max(0, _fuelLevel - 1);
      });
    }

    // Check if all constellation stars in the current sector have been visited
    _checkConstellationCompletion();

    // Force a redraw
    setState(() {});
  }

  void _setupLevel() {
    // Create a new physics world
    _world = World(Vector2(0, 0.2));

    // Reset game state
    _stars = [];
    _gravityFields = [];
    _anomalies = [];
    _constellations = [];
    _fuelLevel = 100;
    _levelCompleted = false;
    _completedConstellation = null;

    // Create spaceship
    _spaceship = SpaceshipBody(_world, Vector2(0, 0));

    // Get constellation for current sector
    final constellationLevel = ConstellationDataService.levels[_currentSector];
    final constellationInfo =
        ConstellationDataService.getConstellationInfo(constellationLevel.name);

    // Create constellation zone
    final constellation = ConstellationZone(
      name: constellationLevel.name,
      stars: constellationLevel.starPositions.map((pos) {
        // Convert normalized coordinates to world coordinates
        final worldX = (pos.dx - 0.5) * 20.0; // 20 units wide
        final worldY = (pos.dy - 0.5) * 20.0; // 20 units high

        // Create a star body in the physics world
        final star = StarBody(_world, Vector2(worldX, worldY));
        _stars.add(star);

        return StarPosition(position: Vector2(worldX, worldY), visited: false);
      }).toList(),
      connections: constellationLevel.connections,
    );

    _constellations.add(constellation);

    // Add gravity fields based on constellation complexity
    for (int i = 0; i < 2 + _currentSector; i++) {
      final x = math.Random().nextDouble() * 20.0 - 10.0;
      final y = math.Random().nextDouble() * 20.0 - 10.0;
      final strength =
          (0.5 + math.Random().nextDouble() * 0.5) * (_currentSector + 1);
      final radius = 2.0 + math.Random().nextDouble() * 3.0;

      // Don't place gravity fields too close to stars
      bool tooClose = false;
      for (var star in _stars) {
        final distance = (star.position - Vector2(x, y)).length;
        if (distance < radius + 2.0) {
          tooClose = true;
          break;
        }
      }

      if (!tooClose) {
        _gravityFields
            .add(GravityFieldBody(_world, Vector2(x, y), strength, radius));
      }
    }

    // Add space anomalies
    for (int i = 0; i < _currentSector; i++) {
      final x = math.Random().nextDouble() * 20.0 - 10.0;
      final y = math.Random().nextDouble() * 20.0 - 10.0;
      final radius = 1.0 + math.Random().nextDouble();

      // Don't place anomalies too close to stars or gravity fields
      bool tooClose = false;
      for (var star in _stars) {
        final distance = (star.position - Vector2(x, y)).length;
        if (distance < radius + 2.0) {
          tooClose = true;
          break;
        }
      }

      for (var field in _gravityFields) {
        final distance = (field.position - Vector2(x, y)).length;
        if (distance < radius + field.radius) {
          tooClose = true;
          break;
        }
      }

      if (!tooClose) {
        _anomalies.add(AnomalyBody(_world, Vector2(x, y), radius));
      }
    }

    // Position spaceship at a safe starting point
    final startPos = Vector2(-8, 8);
    _spaceship.body.setTransform(startPos, 0);

    // Set current objective
    _currentObjective = "Discover the ${constellationLevel.name} constellation";
  }

  void _updateSpaceshipControls() {
    // Apply thruster force if active
    if (_thrusterActive && _fuelLevel > 0) {
      // Get spaceship's current angle
      final angle = _spaceship.body.angle;

      // Calculate force vector
      final force = Vector2(
        math.cos(angle) * 10.0,
        math.sin(angle) * 10.0,
      );

      // Apply force at the center of the ship
      _spaceship.body.applyForce(force);

      // Animate thruster
      if (!_thrusterAnimationController.isAnimating) {
        _thrusterAnimationController.forward();
      }
    } else if (_thrusterAnimationController.isAnimating) {
      _thrusterAnimationController.reverse();
    }

    // Apply rotation if a direction is set
    if (_rotationDirection != 0) {
      _spaceship.body.applyTorque(_rotationDirection * 2.0);
    }
  }

  void _checkCollisions() {
    // Get spaceship position
    final shipPos = _spaceship.body.position;

    // Check collisions with stars
    for (var i = 0; i < _stars.length; i++) {
      final star = _stars[i];
      final distance = (star.position - shipPos).length;

      // If ship is close to star, mark it as visited
      if (distance < 2.0) {
        // Find the constellation this star belongs to
        for (var constellation in _constellations) {
          if (i < constellation.stars.length &&
              !constellation.stars[i].visited) {
            setState(() {
              constellation.stars[i].visited = true;
              _score += 100;

              // Play sound effect
              SoundController().playSound('connect');
            });

            // Apply vibration
            HapticFeedback.lightImpact();
          }
        }
      }
    }

    // Check collisions with fuel pickups
    // (to be implemented)

    // Apply gravity field effects
    for (var field in _gravityFields) {
      final toField = field.position - shipPos;
      final distance = toField.length;

      // Apply gravity if ship is within the field's radius
      if (distance < field.radius) {
        // Calculate force based on distance (stronger when closer)
        final forceMagnitude = field.strength * (1.0 - distance / field.radius);

        // Create normalized direction vector
        final forceDir = toField.normalized();

        // Apply gravity force
        _spaceship.body.applyForce(forceDir.scaled(forceMagnitude));
      }
    }

    // Check collisions with anomalies
    for (var anomaly in _anomalies) {
      final distance = (anomaly.position - shipPos).length;

      // If ship enters anomaly, apply random effect
      if (distance < anomaly.radius) {
        // Random spin effect
        _spaceship.body.applyTorque((math.Random().nextDouble() * 10.0 - 5.0));

        // Drain some fuel
        setState(() {
          _fuelLevel = math.max(0, _fuelLevel - 1);
        });
      }
    }
  }

  void _checkConstellationCompletion() {
    for (var constellation in _constellations) {
      // Check if all stars in the constellation have been visited
      bool allVisited = constellation.stars.every((star) => star.visited);

      if (allVisited &&
          !_discoveredConstellations.contains(constellation.name)) {
        setState(() {
          _discoveredConstellations.add(constellation.name);
          _levelCompleted = true;
          _completedConstellation = constellation.name;
          _score += 1000;
        });

        // Play success sound
        SoundController().playSound('success');

        // Show completion dialog after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          _showConstellationCompletedDialog(constellation.name);
        });
      }
    }
  }

  void _showConstellationCompletedDialog(String constellationName) {
    final info =
        ConstellationDataService.getConstellationInfo(constellationName);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Constellation Discovered!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                constellationName,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                info.mythology,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  // Move to next sector if available
                  if (_currentSector <
                      ConstellationDataService.levels.length - 1) {
                    setState(() {
                      _currentSector++;
                      _setupLevel();
                    });
                  } else {
                    // Game completed
                    Navigator.popAndPushNamed(context, '/menu');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text(
                  _currentSector < ConstellationDataService.levels.length - 1
                      ? 'Continue to Next Sector'
                      : 'Complete Expedition',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    _touchPosition = details.localPosition;
    setState(() {
      _thrusterActive = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    _touchPosition = null;
    setState(() {
      _thrusterActive = false;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_touchPosition != null) {
      final dragVector = details.localPosition - _touchPosition!;

      // Use horizontal drag for rotation
      setState(() {
        _rotationDirection = dragVector.dx / 50.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(gameThemeProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: BackgroundGradient(
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onPanUpdate: _handleDragUpdate,
          onPanEnd: (_) {
            setState(() {
              _thrusterActive = false;
              _rotationDirection = 0;
            });
          },
          child: Stack(
            children: [
              // Game view
              CustomPaint(
                size: size,
                painter: GamePainter(
                  spaceship: _spaceship,
                  stars: _stars,
                  gravityFields: _gravityFields,
                  anomalies: _anomalies,
                  constellations: _constellations,
                  thrusterAnimation: _thrusterAnimationController,
                  starTwinkleAnimation: _starTwinkleController,
                  viewportZoom: _viewportZoom,
                  viewportPosition: _viewportPosition,
                  theme: theme.config,
                ),
              ),

              // UI overlay
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back button
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),

                          // Score
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Score: $_score',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Current objective
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _currentObjective,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Fuel gauge
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fuel',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 10,
                            width: size.width - 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: _fuelLevel / 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange,
                                      Colors.yellow,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Controls explanation
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Tap and hold to activate thrusters\nDrag horizontally to rotate',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Game objects

class SpaceshipBody {
  final World world;
  late Body body;

  SpaceshipBody(this.world, Vector2 position) {
    // Create body definition
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position;

    // Create body
    body = world.createBody(bodyDef);

    // Create ship shape as a polygon
    final shape = PolygonShape()
      ..set([
        Vector2(1.0, 0.0), // Nose
        Vector2(-0.6, 0.5), // Left wing
        Vector2(-0.3, 0.0), // Left body
        Vector2(-0.3, 0.0), // Right body
        Vector2(-0.6, -0.5), // Right wing
      ]);

    // Create fixture definition
    final fixtureDef = FixtureDef(shape)
      ..density = 1.0
      ..friction = 0.3
      ..restitution = 0.5;

    // Attach fixture to body
    body.createFixture(fixtureDef);

    // Set damping to simulate space friction
    body.linearDamping = 0.1;
    body.angularDamping = 0.1;
  }

  Vector2 get position => body.position;
  double get angle => body.angle;
}

class StarBody {
  final World world;
  final Vector2 position;

  StarBody(this.world, this.position) {
    // Stars are not physical bodies in the simulation,
    // they're just visual elements with a position
  }
}

class GravityFieldBody {
  final World world;
  final Vector2 position;
  final double strength;
  final double radius;

  GravityFieldBody(this.world, this.position, this.strength, this.radius);
}

class AnomalyBody {
  final World world;
  final Vector2 position;
  final double radius;

  AnomalyBody(this.world, this.position, this.radius);
}

class StarPosition {
  final Vector2 position;
  bool visited;

  StarPosition({required this.position, this.visited = false});
}

class ConstellationZone {
  final String name;
  final List<StarPosition> stars;
  final List<List<int>> connections;

  ConstellationZone(
      {required this.name, required this.stars, required this.connections});
}

// Custom painter for the game
class GamePainter extends CustomPainter {
  final SpaceshipBody spaceship;
  final List<StarBody> stars;
  final List<GravityFieldBody> gravityFields;
  final List<AnomalyBody> anomalies;
  final List<ConstellationZone> constellations;
  final AnimationController thrusterAnimation;
  final AnimationController starTwinkleAnimation;
  final double viewportZoom;
  final Offset viewportPosition;
  final ThemeConfig theme;

  GamePainter({
    required this.spaceship,
    required this.stars,
    required this.gravityFields,
    required this.anomalies,
    required this.constellations,
    required this.thrusterAnimation,
    required this.starTwinkleAnimation,
    required this.viewportZoom,
    required this.viewportPosition,
    required this.theme,
  }) : super(
            repaint:
                Listenable.merge([thrusterAnimation, starTwinkleAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    // Set up viewport transformation
    final viewportTransform = getViewportTransform(size);
    canvas.save();
    canvas.transform(viewportTransform.storage);

    // Draw background stars (fixed, part of the background)
    _drawBackgroundStars(canvas, size);

    // Draw constellation connections
    _drawConstellationConnections(canvas);

    // Draw gravity fields
    _drawGravityFields(canvas);

    // Draw anomalies
    _drawAnomalies(canvas);

    // Draw stars
    _drawStars(canvas);

    // Draw spaceship
    _drawSpaceship(canvas);

    // Restore canvas
    canvas.restore();
  }

  Matrix4 getViewportTransform(Size size) {
    // Scale from physics world to screen coordinates
    final scale = worldScale * viewportZoom;

    // Calculate viewport center
    final viewportCenter = Offset(
      size.width / 2 + viewportPosition.dx,
      size.height / 2 + viewportPosition.dy,
    );

    // Create transformation matrix
    return Matrix4.identity()
      ..translate(viewportCenter.dx, viewportCenter.dy)
      ..scale(scale, scale)
      ..translate(-spaceship.position.x, -spaceship.position.y);
  }

  void _drawBackgroundStars(Canvas canvas, Size size) {
    final random = math.Random(42);
    final starPaint = Paint()
      ..color = theme.starColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Create a local pseudorandom star field based on current position
    final baseX = (spaceship.position.x ~/ 10) * 10;
    final baseY = (spaceship.position.y ~/ 10) * 10;

    for (int x = -2; x <= 2; x++) {
      for (int y = -2; y <= 2; y++) {
        // Current sector
        final sectorX = baseX + x * 10;
        final sectorY = baseY + y * 10;

        // Generate deterministic random stars for this sector
        final sectorRandom = math.Random(sectorX * 10000 + sectorY);

        // Number of stars in this sector
        final starCount = 20 + sectorRandom.nextInt(30);

        for (int i = 0; i < starCount; i++) {
          final starX = sectorX + sectorRandom.nextDouble() * 10;
          final starY = sectorY + sectorRandom.nextDouble() * 10;

          // Star size and twinkle based on animation
          final baseSize = 0.05 + sectorRandom.nextDouble() * 0.1;
          final twinkleFactor = 0.5 +
              0.5 *
                  (sectorRandom.nextInt(2) == 0
                      ? starTwinkleAnimation.value
                      : 1 - starTwinkleAnimation.value);

          final size = baseSize * twinkleFactor;

          canvas.drawCircle(
            Offset(starX, starY),
            size,
            starPaint
              ..color = theme.starColor.withOpacity(0.3 + 0.7 * twinkleFactor),
          );
        }
      }
    }
  }

  void _drawConstellationConnections(Canvas canvas) {
    for (var constellation in constellations) {
      final linePaint = Paint()
        ..color = theme.lineColor.withOpacity(0.3)
        ..strokeWidth = 0.05
        ..style = PaintingStyle.stroke;

      final completedLinePaint = Paint()
        ..color = theme.completedLineColor
        ..strokeWidth = 0.08
        ..style = PaintingStyle.stroke;

      // Draw connections between stars
      for (var connection in constellation.connections) {
        if (connection.length == 2) {
          final star1 = constellation.stars[connection[0]];
          final star2 = constellation.stars[connection[1]];

          // Determine if this connection is complete
          final isComplete = star1.visited && star2.visited;

          canvas.drawLine(
            Offset(star1.position.x, star1.position.y),
            Offset(star2.position.x, star2.position.y),
            isComplete ? completedLinePaint : linePaint,
          );
        }
      }
    }
  }

  void _drawGravityFields(Canvas canvas) {
    for (var field in gravityFields) {
      final fieldPaint = Paint()
        ..color = Colors.purpleAccent.withOpacity(0.1)
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = Colors.purpleAccent.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.1;

      // Draw gravity field as a circle
      canvas.drawCircle(
        Offset(field.position.x, field.position.y),
        field.radius,
        fieldPaint,
      );

      canvas.drawCircle(
        Offset(field.position.x, field.position.y),
        field.radius,
        borderPaint,
      );

      // Draw center point
      canvas.drawCircle(
        Offset(field.position.x, field.position.y),
        0.2,
        Paint()..color = Colors.purpleAccent.withOpacity(0.7),
      );
    }
  }

  void _drawAnomalies(Canvas canvas) {
    for (var anomaly in anomalies) {
      // Create a radial gradient for the anomaly
      final gradient = RadialGradient(
        colors: [
          Colors.red.withOpacity(0.7),
          Colors.orange.withOpacity(0.5),
          Colors.yellow.withOpacity(0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      );

      final anomalyPaint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(
            center: Offset(anomaly.position.x, anomaly.position.y),
            radius: anomaly.radius,
          ),
        )
        ..style = PaintingStyle.fill;

      // Draw anomaly as a circle with gradient
      canvas.drawCircle(
        Offset(anomaly.position.x, anomaly.position.y),
        anomaly.radius,
        anomalyPaint,
      );

      // Add some distortion effects
      final time = DateTime.now().millisecondsSinceEpoch / 1000.0;

      for (int i = 0; i < 3; i++) {
        final angle = time * (i + 1) * 0.5;
        final offsetX = math.cos(angle) * 0.3;
        final offsetY = math.sin(angle) * 0.3;

        canvas.drawCircle(
          Offset(
            anomaly.position.x + offsetX,
            anomaly.position.y + offsetY,
          ),
          anomaly.radius * 0.3,
          Paint()..color = Colors.redAccent.withOpacity(0.3),
        );
      }
    }
  }

  void _drawStars(Canvas canvas) {
    for (var i = 0; i < stars.length; i++) {
      final star = stars[i];

      // Determine if star has been visited
      bool visited = false;
      for (var constellation in constellations) {
        if (i < constellation.stars.length && constellation.stars[i].visited) {
          visited = true;
          break;
        }
      }

      final starPaint = Paint()
        ..color = visited ? theme.activeStarColor : theme.starColor
        ..style = PaintingStyle.fill;

      // Draw star glow
      final glowPaint = Paint()
        ..color =
            (visited ? theme.activeStarColor : theme.starColor).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);

      // Star twinkle animation if not visited
      double size = 0.2;
      if (!visited) {
        // Different stars twinkle at different rates
        final twinkleFactor = i % 2 == 0
            ? starTwinkleAnimation.value
            : 1 - starTwinkleAnimation.value;

        size = 0.15 + 0.05 * twinkleFactor;
        starPaint.color =
            theme.starColor.withOpacity(0.5 + 0.5 * twinkleFactor);
      } else {
        size = 0.25; // Bigger for visited stars
      }

      // Draw glow
      canvas.drawCircle(
        Offset(star.position.x, star.position.y),
        size * 3,
        glowPaint,
      );

      // Draw star
      canvas.drawCircle(
        Offset(star.position.x, star.position.y),
        size,
        starPaint,
      );

      // Draw star sparkles if visited
      if (visited) {
        final time = DateTime.now().millisecondsSinceEpoch / 300.0;

        for (int j = 0; j < 4; j++) {
          final angle = time * 0.1 + j * math.pi / 2;
          final distance = 0.3 + 0.1 * math.sin(time * 0.5 + j);

          canvas.drawCircle(
            Offset(
              star.position.x + math.cos(angle) * distance,
              star.position.y + math.sin(angle) * distance,
            ),
            0.05,
            Paint()..color = theme.activeStarColor.withOpacity(0.7),
          );
        }
      }
    }
  }

  void _drawSpaceship(Canvas canvas) {
    // Save current canvas state
    canvas.save();

    // Translate and rotate canvas to ship position and angle
    canvas.translate(spaceship.position.x, spaceship.position.y);
    canvas.rotate(spaceship.angle);

    // Draw ship body
    final shipPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(1.0, 0.0) // Nose
      ..lineTo(-0.6, 0.5) // Left wing
      ..lineTo(-0.3, 0.0) // Left body
      ..lineTo(-0.6, -0.5) // Right wing
      ..close(); // Back to nose

    canvas.drawPath(path, shipPaint);

    // Draw ship outline
    final outlinePaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.05;

    canvas.drawPath(path, outlinePaint);

    // Draw thruster if active
    if (thrusterAnimation.value > 0) {
      final thrusterPaint = Paint()
        ..color = Colors.orange.withOpacity(thrusterAnimation.value)
        ..style = PaintingStyle.fill;

      final innerThrusterPaint = Paint()
        ..color = Colors.yellow.withOpacity(thrusterAnimation.value)
        ..style = PaintingStyle.fill;

      // Thruster flame path
      final thrusterPath = Path()
        ..moveTo(-0.6, 0.2)
        ..lineTo(-1.5 - thrusterAnimation.value * 0.5, 0.0)
        ..lineTo(-0.6, -0.2)
        ..close();

      // Inner flame
      final innerThrusterPath = Path()
        ..moveTo(-0.6, 0.1)
        ..lineTo(-1.2 - thrusterAnimation.value * 0.3, 0.0)
        ..lineTo(-0.6, -0.1)
        ..close();

      canvas.drawPath(thrusterPath, thrusterPaint);
      canvas.drawPath(innerThrusterPath, innerThrusterPaint);
    }

    // Restore canvas state
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
