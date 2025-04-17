import 'package:forge2d/forge2d.dart';

/// Represents a star in space that can be discovered
class Star {
  final int id;
  final Vector2 position;
  final double radius;
  final double brightness;
  bool discovered;

  Star({
    required this.id,
    required this.position,
    required this.radius,
    required this.brightness,
    this.discovered = false,
  });
}

/// Represents a celestial body with gravitational pull
class CelestialBody {
  final int id;
  final String name;
  final String type; // planet, dwarf planet, asteroid, etc.
  final Vector2 position;
  final double radius;
  final double mass;
  final double rotationSpeed;
  final Color color;

  CelestialBody({
    required this.id,
    required this.name,
    required this.type,
    required this.position,
    required this.radius,
    required this.mass,
    required this.rotationSpeed,
    required this.color,
  });
}

/// Represents a discovered constellation
class DiscoveredConstellation {
  final String name;
  final List<int> starIds;
  final String story;
  final UnlockableAbility? unlockedAbility;
  final DateTime discoveryTime;

  DiscoveredConstellation({
    required this.name,
    required this.starIds,
    required this.story,
    this.unlockedAbility,
    required this.discoveryTime,
  });
}

/// Represents abilities that can be unlocked by discovering constellations
class UnlockableAbility {
  final String name;
  final String description;
  final AbilityType type;
  final double value;

  UnlockableAbility({
    required this.name,
    required this.description,
    required this.type,
    required this.value,
  });
}

/// Types of abilities that can be unlocked
enum AbilityType {
  increasedFuel,
  improvedThrust,
  enhancedShielding,
  expandedScanRange,
  wormholeNavigation,
}

/// Represents a color in the game
class Color {
  final int r;
  final int g;
  final int b;
  final double opacity;

  const Color(this.r, this.g, this.b, {this.opacity = 1.0});

  static const Color red = Color(255, 0, 0);
  static const Color green = Color(0, 255, 0);
  static const Color blue = Color(0, 0, 255);
  static const Color yellow = Color(255, 255, 0);
  static const Color purple = Color(128, 0, 128);
  static const Color cyan = Color(0, 255, 255);
  static const Color orange = Color(255, 165, 0);
  static const Color white = Color(255, 255, 255);
}

/// Represents a region in space
class SpaceRegion {
  final String name;
  final String description;
  final List<Vector2> boundaryPoints;
  final double dangerLevel; // 0.0 to 1.0
  final List<String> unlockedByConstellations;
  final bool discovered;

  SpaceRegion({
    required this.name,
    required this.description,
    required this.boundaryPoints,
    required this.dangerLevel,
    required this.unlockedByConstellations,
    this.discovered = false,
  });

  bool isPointInRegion(Vector2 point) {
    // Implementation of the point-in-polygon algorithm
    bool inside = false;
    for (int i = 0, j = boundaryPoints.length - 1;
        i < boundaryPoints.length;
        j = i++) {
      final vi = boundaryPoints[i];
      final vj = boundaryPoints[j];

      final intersect = ((vi.y > point.y) != (vj.y > point.y)) &&
          (point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x);

      if (intersect) inside = !inside;
    }

    return inside;
  }
}

/// Represents a mission or objective
class SpaceMission {
  final String title;
  final String description;
  final MissionType type;
  final List<MissionObjective> objectives;
  final String reward;
  final bool completed;

  SpaceMission({
    required this.title,
    required this.description,
    required this.type,
    required this.objectives,
    required this.reward,
    this.completed = false,
  });

  double get progress {
    if (objectives.isEmpty) return 0.0;

    final completedCount = objectives.where((obj) => obj.completed).length;
    return completedCount / objectives.length;
  }
}

/// Types of missions
enum MissionType {
  exploration,
  discovery,
  collection,
  navigation,
  rescue,
}

/// Represents a single mission objective
class MissionObjective {
  final String description;
  final bool completed;

  MissionObjective({
    required this.description,
    this.completed = false,
  });
}

/// Represents the player's progress in the game
class PlayerProgress {
  final int totalStarsDiscovered;
  final int totalConstellationsDiscovered;
  final int totalRegionsExplored;
  final int totalMissionsCompleted;
  final List<UnlockableAbility> unlockedAbilities;
  final Map<String, bool> unlockedRegions;
  final Map<String, double> resourceInventory;

  PlayerProgress({
    this.totalStarsDiscovered = 0,
    this.totalConstellationsDiscovered = 0,
    this.totalRegionsExplored = 0,
    this.totalMissionsCompleted = 0,
    this.unlockedAbilities = const [],
    this.unlockedRegions = const {},
    this.resourceInventory = const {},
  });

  PlayerProgress copyWith({
    int? totalStarsDiscovered,
    int? totalConstellationsDiscovered,
    int? totalRegionsExplored,
    int? totalMissionsCompleted,
    List<UnlockableAbility>? unlockedAbilities,
    Map<String, bool>? unlockedRegions,
    Map<String, double>? resourceInventory,
  }) {
    return PlayerProgress(
      totalStarsDiscovered: totalStarsDiscovered ?? this.totalStarsDiscovered,
      totalConstellationsDiscovered:
          totalConstellationsDiscovered ?? this.totalConstellationsDiscovered,
      totalRegionsExplored: totalRegionsExplored ?? this.totalRegionsExplored,
      totalMissionsCompleted:
          totalMissionsCompleted ?? this.totalMissionsCompleted,
      unlockedAbilities: unlockedAbilities ?? this.unlockedAbilities,
      unlockedRegions: unlockedRegions ?? this.unlockedRegions,
      resourceInventory: resourceInventory ?? this.resourceInventory,
    );
  }
}
