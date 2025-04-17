class GameConfig {
  // Screen dimensions will be calculated relative to these values
  static const double designWidth = 375.0;
  static const double designHeight = 812.0;

  // Game settings
  static const int maxRetries = 3;
  static const double starHitboxRadius = 0.02; // Relative to screen width
  static const Duration starTwinkleInterval = Duration(milliseconds: 1500);
  static const Duration lineDrawTimeout = Duration(seconds: 30);

  static const Duration levelTimeLimit = Duration(minutes: 10);

  // Scoring
  static const int baseScore = 100;
  static const int timeBonus = 50;
  static const int perfectDrawBonus = 25;

  // Physics world dimensions
  static const double worldWidth = 1000.0;
  static const double worldHeight = 1000.0;

  // Starfield settings
  static const double starDensity = 0.0002; // Stars per unit area
  static const double twinkleIntensity = 0.3;

  // Ship settings
  static const double shipSize = 10.0;
  static const double shipMaxThrust = 10.0;
  static const double shipRotationSpeed = 0.1;
  static const double shipMaxVelocity = 20.0;
  static const double shipInitialFuel = 100.0;
  static const double shipFuelConsumption = 0.1; // Per second when thrusting

  // Game mechanics
  static const double starDiscoveryRadius =
      5.0; // How close to "discover" a star
  static const double gravityFieldStrength = 20.0;
  static const double anomalyStrengthMultiplier = 2.0;
  static const double wormholeRadius = 15.0;

  // Game progression
  static const int constellationCompletionBonus = 500;
  static const int fuelEfficiencyBonus = 25;

  // Level progression
  static const List<String> regionProgression = [
    'Solar Neighborhood',
    'Celestial Gateway',
    'Persean Nebula',
    'Polar Expanse',
    'Antares Sector',
    'Orion Arm',
    'Vega Sector',
    'Northern Cross',
    'Andromeda Approach',
  ];

  // Unlockable content thresholds
  static const int starsForBasicShipUpgrade = 10;
  static const int starsForAdvancedNavigation = 25;
  static const int starsForWormholeTechnology = 50;

  // Audio settings
  static const double defaultMusicVolume = 0.3;
  static const double defaultSoundEffectsVolume = 0.5;
}

// ca-app-pub-5153941317881091~6156142017
// ca-app-pub-5153941317881091/4277590731
