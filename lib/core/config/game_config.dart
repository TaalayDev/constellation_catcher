class GameConfig {
  // Screen dimensions will be calculated relative to these values
  static const double designWidth = 375.0;
  static const double designHeight = 812.0;

  // Game settings
  static const int maxRetries = 3;
  static const double starHitboxRadius = 0.02; // Relative to screen width
  static const Duration starTwinkleInterval = Duration(milliseconds: 1500);
  static const Duration lineDrawTimeout = Duration(seconds: 30);

  // Scoring
  static const int baseScore = 100;
  static const int timeBonus = 50;
  static const int perfectDrawBonus = 25;
}

// ca-app-pub-5153941317881091~6156142017
// ca-app-pub-5153941317881091/4277590731
