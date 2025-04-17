import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

// --- Game Configuration ---
const double starSize = 15.0;
const double catcherSize = 50.0;
const double catcherSpeed = 200.0; // Speed at which catcher follows input

class ConstellationCatcherGameScreen extends StatelessWidget {
  const ConstellationCatcherGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Constellation Catcher'),
      ),
      body: GameWidget<ConstellationCatcherGame>(
        game: ConstellationCatcherGame(),
        overlayBuilderMap: {
          'score': (context, game) {
            return Positioned(
              top: 20,
              left: 20,
              child: ValueListenableBuilder<int>(
                valueListenable: game.score,
                builder: (context, score, child) {
                  return Text(
                    'Score: $score',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                  );
                },
              ),
            );
          },
        },
        initialActiveOverlays: ['score'], // Show score overlay by default
      ),
      backgroundColor: Colors.black, // Dark background for space theme
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Restart the game or perform any action
          // For example, you could reset the score or reload the game.
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

// --- Main Game Class ---
class ConstellationCatcherGame extends Forge2DGame
    with HasCollisionDetection, TapDetector, PanDetector {
  // Keep track of the score
  final ValueNotifier<int> score = ValueNotifier(0);
  // Reference to the player's catcher
  Catcher? _catcher;
  // Timer for spawning stars
  late Timer _starSpawner;
  // Boundaries for the game world
  late List<Component> boundaries;

  ConstellationCatcherGame()
      : super(
          gravity: Vector2(0, 50),
          zoom: 10,
        ); // Gravity pulls stars down

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Create boundaries around the screen
    boundaries = createBoundaries(this);
    addAll(boundaries);

    // Create and add the catcher
    _catcher = Catcher(
      position: screenToWorld(size / 2), // Start in the center
      size: Vector2.all(catcherSize),
    );
    add(_catcher!);

    // Set up star spawner timer
    _starSpawner = Timer(1.0,
        onTick: _spawnStar, repeat: true); // Spawn a star every second
    _starSpawner.start();

    // --- Placeholder for Background ---
    // TODO: Add a background component.
    // You could use a SpriteComponent with a placeholder color or
    // eventually load an image.
    // Example placeholder:
    // add(RectangleComponent(
    //   size: size, // Use game size
    //   paint: Paint()..color = Colors.black87,
    //   priority: -1, // Render behind everything else
    // ));
    // --- Image Generation Prompt ---
    // Generate a starry night sky background image (e.g., 1080x1920 pixels)
    // with deep blues, purples, and scattered bright stars/nebulae.
    // Prompt: "Deep space background, starry night sky with vibrant nebulae clouds in blue and purple hues, suitable for a mobile game background, 1080x1920 aspect ratio."
  }

  @override
  void update(double dt) {
    super.update(dt);
    _starSpawner.update(dt); // Update the spawner timer
  }

  // --- Input Handling ---
  Vector2? _dragPosition;

  @override
  void onPanStart(DragStartInfo info) {
    _dragPosition = info.eventPosition.global;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _dragPosition = info.eventPosition.global;
    if (_catcher != null && _dragPosition != null) {
      // Move catcher towards the drag position smoothly
      final targetWorldPosition = screenToWorld(_dragPosition!);
      _catcher!.setTargetPosition(targetWorldPosition);
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _dragPosition = null;
    _catcher?.stop(); // Stop catcher movement when drag ends
  }

  @override
  void onPanCancel() {
    _dragPosition = null;
    _catcher?.stop();
  }

  // --- Star Spawning ---
  final Random _random = Random();
  void _spawnStar() {
    if (!isMounted) return; // Don't spawn if game is not ready

    // Calculate random horizontal position within screen bounds
    final screenWidth = size.x;
    final worldWidth =
        screenToWorld(Vector2(screenWidth, 0)).x * 2; // Approx world width
    final spawnX = (_random.nextDouble() * worldWidth) - (worldWidth / 2);

    // Spawn slightly above the top edge
    final spawnY = screenToWorld(Vector2(0, -starSize * 2)).y;

    final star = Star(
      position: Vector2(spawnX, spawnY),
      size: Vector2.all(starSize),
    );
    add(star);
  }

  // --- Score Management ---
  void increaseScore() {
    score.value++;
  }

  // --- Boundary Creation ---
  List<Component> createBoundaries(Forge2DGame game) {
    final topLeft = Vector2.zero();
    final bottomRight = game.screenToWorld(game.camera.viewport.size);
    final topRight = Vector2(bottomRight.x, topLeft.y);
    final bottomLeft = Vector2(topLeft.x, bottomRight.y);

    // Keep stars from falling off the bottom, left, and right.
    // Top is open for stars to fall in.
    return [
      Wall(topLeft, topRight), // Top edge (optional, stars spawn above)
      Wall(topRight, bottomRight), // Right edge
      Wall(bottomLeft,
          bottomRight), // Bottom edge (stars will rest here if not caught)
      Wall(topLeft, bottomLeft), // Left edge
    ];
  }
}

// --- Wall Component (Boundary) ---
class Wall extends BodyComponent {
  final Vector2 start;
  final Vector2 end;

  Wall(this.start, this.end);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(
      position: Vector2.zero(), // Positioned globally
      type: BodyType.static,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

// --- Catcher Component ---
class Catcher extends BodyComponent with ContactCallbacks {
  final Vector2 position;
  final Vector2 size;
  Vector2? _targetPosition; // Where the catcher should move towards
  Vector2 _velocity = Vector2.zero();

  Catcher({required this.position, required this.size}) : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Add a visual representation (e.g., circle)
    add(CircleComponent(
      radius: size.x / 2, // Use size.x assuming square/circle
      paint: Paint()..color = Colors.blueAccent,
      anchor: Anchor.center,
    ));
    // --- Placeholder for Catcher Visual ---
    // TODO: Replace CircleComponent with a SpriteComponent for a custom look.
    // --- Image Generation Prompt ---
    // Generate an image of a stylized net or a small, friendly spaceship
    // to represent the catcher. Ensure it has a transparent background.
    // Prompt: "Stylized cartoon catching net with a glowing blue rim, transparent background, suitable for a 2D mobile game asset, circular shape."
    // OR
    // Prompt: "Small, friendly cartoon spaceship, top-down view, blue and silver colors, transparent background, suitable for a 2D mobile game asset."
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 2; // Adjust for world scale
    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.1,
      density: 1.0,
      friction: 0.5,
      userData: this, // Pass component reference for collision callbacks
    );
    final bodyDef = BodyDef(
      userData: this,
      position: position,
      type: BodyType
          .kinematic, // Kinematic allows control without full physics simulation
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  void setTargetPosition(Vector2 target) {
    _targetPosition = target;
  }

  void stop() {
    _targetPosition = null;
    body.linearVelocity = Vector2.zero(); // Stop immediately
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move towards the target position if set
    if (_targetPosition != null) {
      // Calculate direction vector from current position to target
      final direction = (_targetPosition! - body.position);
      // Calculate distance to target
      final distance = direction.length;

      // If far enough away, move towards target
      // Use a threshold slightly larger than potential physics jitter/step size
      if (distance > 0.1) {
        // Set kinematic velocity directly towards the target at defined speed
        // Velocity is in world units per second
        body.linearVelocity = direction.normalized() * catcherSpeed;
      } else {
        // Close enough, stop moving and clear target
        body.linearVelocity = Vector2.zero();
        _targetPosition = null; // Reached target
      }
    } else {
      // Ensure velocity is zero if no target is set
      body.linearVelocity = Vector2.zero();
    }
  }

  // Contact callbacks (handled globally in StarContactCallback for simplicity here)
}

// --- Star Component ---
class Star extends BodyComponent with ContactCallbacks {
  final Vector2 position;
  final Vector2 size;
  bool _isCaught = false;

  Star({required this.position, required this.size}) : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Add a visual representation (e.g., circle)
    // --- Placeholder for Star Visual ---
    // TODO: Replace CircleComponent with a SpriteComponent for a custom look.
    // You could use different colors or shapes for variety.
    // --- Image Generation Prompt ---
    // Generate a simple, glowing star icon with a transparent background.
    // Maybe create a few variations (different colors, slightly different shapes).
    // Prompt: "Simple glowing yellow star icon, cartoon style, transparent background, suitable for a 2D mobile game asset."
    add(
      CircleComponent(
        radius: size.x / 2, // Use size.x assuming square/circle
        paint: Paint()..color = Colors.yellowAccent,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 2; // Adjust for world scale
    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.4, // Bouncy
      density: 0.5,
      friction: 0.2,
      userData: this, // Pass component reference for collision callbacks
    );
    final bodyDef = BodyDef(
      userData: this,
      position: position,
      type: BodyType.dynamic, // Stars fall due to gravity
      angularDamping: 0.8,
      linearDamping: 0.1,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Catcher) {
      // Called when a star hits the catcher
      if (!_isCaught) {
        catchStar();
      }
    }
  }

  // Method called when caught
  void catchStar() {
    if (_isCaught) return; // Prevent multiple catches
    _isCaught = true;

    // Add a visual effect (e.g., fade out and scale up)
    add(RemoveEffect(
      delay: 0.2, // Short delay before removal
    ));
    add(ScaleEffect.to(
      Vector2.all(1.5), // Scale up slightly
      EffectController(duration: 0.2),
    ));
    add(OpacityEffect.fadeOut(
      EffectController(duration: 0.2),
    ));

    // Find the game instance to increase score
    final game = findGame()! as ConstellationCatcherGame;
    game.increaseScore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Remove star if it falls too far off screen (optional cleanup)
    final game = findGame()! as ConstellationCatcherGame;
    final bottomBoundary = game.screenToWorld(game.size).y;
    if (body.position.y > bottomBoundary + size.y * 5) {
      // Check if well below screen
      removeFromParent();
    }
  }
}
