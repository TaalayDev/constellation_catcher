import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart';
import 'dart:math' as math;

class SpaceshipPhysics {
  static const double SHIP_DENSITY = 1.0;
  static const double SHIP_FRICTION = 0.1;
  static const double SHIP_RESTITUTION = 0.2;
  static const double THRUST_FORCE = 10.0;
  static const double ROTATION_TORQUE = 5.0;
  static const double MAX_VELOCITY = 20.0;

  Body? _shipBody;
  final World _world;

  // Ship shape definition
  final List<Vector2> _shipVertices = [
    Vector2(0.0, -2.0), // nose
    Vector2(-1.0, 2.0), // bottom left
    Vector2(0.0, 1.0), // bottom center
    Vector2(1.0, 2.0), // bottom right
  ];

  SpaceshipPhysics(this._world);

  Body createSpaceship(Vector2 position) {
    // Create ship body definition
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position
      ..angularDamping = 0.8
      ..linearDamping = 0.2;

    // Create ship body
    _shipBody = _world.createBody(bodyDef);

    // Create ship shape
    final shipShape = PolygonShape()..set(_shipVertices);

    // Create fixture definition
    final fixtureDef = FixtureDef(shipShape)
      ..density = SHIP_DENSITY
      ..friction = SHIP_FRICTION
      ..restitution = SHIP_RESTITUTION;

    // Attach fixture to body
    _shipBody!.createFixture(fixtureDef);

    return _shipBody!;
  }

  void applyThrust(double amount) {
    if (_shipBody == null) return;

    // Calculate thrust direction based on current rotation
    final angle = _shipBody!.angle;
    final thrustDirection = Vector2(math.sin(angle), -math.cos(angle));

    // Apply force in the direction the ship is pointing
    final force = thrustDirection.scaled(THRUST_FORCE * amount);
    _shipBody!.applyForce(force);

    // Limit velocity
    final velocity = _shipBody!.linearVelocity;
    if (velocity.length > MAX_VELOCITY) {
      velocity.normalize();
      velocity.scale(MAX_VELOCITY);
      _shipBody!.linearVelocity = velocity;
    }
  }

  void applyRotation(double amount) {
    if (_shipBody == null) return;

    // Apply torque for rotation
    _shipBody!.applyTorque(ROTATION_TORQUE * amount);
  }

  Vector2 get position => _shipBody?.position ?? Vector2.zero();
  double get angle => _shipBody?.angle ?? 0.0;
  Vector2 get velocity => _shipBody?.linearVelocity ?? Vector2.zero();
}

class GravityField {
  final Vector2 position;
  final double strength;
  final double radius;

  GravityField({
    required this.position,
    required this.strength,
    required this.radius,
  });

  void applyGravity(Body body) {
    final Vector2 bodyPos = body.position;
    final Vector2 direction = position.clone()..sub(bodyPos);
    final double distance = direction.length;

    // Only apply gravity if within the field's radius
    if (distance <= radius && distance > 0) {
      // Scale gravity by distance (inverse square law)
      final double gravityMagnitude = strength / (distance * distance);

      // Normalize direction and scale by gravity magnitude
      direction.normalize();
      direction.scale(gravityMagnitude);

      // Apply gravitational force
      body.applyForce(direction);
    }
  }
}

class SpaceAnomaly {
  final Vector2 position;
  final double radius;
  final double strengthMultiplier;

  SpaceAnomaly({
    required this.position,
    required this.radius,
    this.strengthMultiplier = 1.0,
  });

  void affectShip(Body shipBody, double deltaTime) {
    final Vector2 shipPos = shipBody.position;
    final double distance = (position - shipPos).length;

    if (distance <= radius) {
      // Apply random turbulence near anomalies
      final random = math.Random();
      final Vector2 turbulence = Vector2(
          (random.nextDouble() * 2.0 - 1.0) * strengthMultiplier,
          (random.nextDouble() * 2.0 - 1.0) * strengthMultiplier);

      // The closer to the center, the stronger the effect
      final double factor = 1.0 - (distance / radius);
      turbulence.scale(factor * deltaTime * 10);

      shipBody.applyForce(turbulence);
      // shipBody.applyForceToCenter(turbulence);
    }
  }
}

class Wormhole {
  final Vector2 entryPosition;
  final Vector2 exitPosition;
  final double radius;

  Wormhole({
    required this.entryPosition,
    required this.exitPosition,
    required this.radius,
  });

  bool checkAndTeleport(Body body) {
    final Vector2 bodyPos = body.position;
    final double distance = (entryPosition - bodyPos).length;

    if (distance <= radius) {
      // Preserve velocity magnitude and direction relative to wormhole orientation
      final Vector2 velocity = body.linearVelocity.clone();

      // Teleport to exit wormhole
      body.setTransform(exitPosition, body.angle);

      // Apply velocity after teleportation
      body.linearVelocity = velocity;

      return true;
    }

    return false;
  }
}
