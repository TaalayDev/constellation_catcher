import '../models/space_objects.dart';

/// Constellation stories, lore, and unlockable abilities
class ConstellationLore {
  static final Map<String, ConstellationStory> _stories = {
    'Triangulum': ConstellationStory(
      name: 'Triangulum',
      title: 'The Navigator\'s Triangle',
      story: '''
Long ago, when the first explorers ventured into the depths of space, they relied on primitive navigation techniques. 
Three brilliant scientists created a triangular formation of beacons to guide travelers safely through the early void.

These beacons, powered by an unusual energy source, have survived eons and continue to emit guidance signals 
that your ship can now detect and utilize to improve its navigation capabilities.

With the Triangulum constellation mapped, your ship's navigation systems can harness this ancient knowledge, 
improving your ability to predict and avoid gravitational anomalies.
''',
      ability: UnlockableAbility(
        name: 'Enhanced Navigation',
        description: 'Gravity field detection range increased by 50%',
        type: AbilityType.expandedScanRange,
        value: 1.5,
      ),
      regionUnlocked: 'Celestial Gateway',
    ),
    'Cassiopeia': ConstellationStory(
      name: 'Cassiopeia',
      title: 'The Queen\'s Fuel',
      story: '''
The ancient queen Cassiopeia was known for her vanity, but legends often overlook her incredible scientific mind. 
According to spacefarer lore, she discovered a method to synthesize efficient reactor fuel from cosmic background radiation.

The W-shaped formation of her constellation is said to represent the wavelength pattern of this unique energy signature.
By mapping this constellation, your ship's systems can adapt her techniques to modern propulsion systems.

Scientists on your homeworld will be eager to analyze this data and implement the improvements to your ship's fuel efficiency.
''',
      ability: UnlockableAbility(
        name: 'Royal Efficiency',
        description: 'Fuel consumption reduced by 30%',
        type: AbilityType.increasedFuel,
        value: 0.7,
      ),
      regionUnlocked: 'Persean Nebula',
    ),
    'Ursa Minor': ConstellationStory(
      name: 'Ursa Minor',
      title: 'The Guardian\'s Shield',
      story: '''
The Little Bear constellation, with Polaris at its tail, has guided travelers for millennia. In space, it serves a similar purpose,
but with an unexpected benefit. The unique arrangement of stars in Ursa Minor creates a resonance pattern that can strengthen shield harmonics.

Ancient protectors of the spaceways encoded their defensive technology into this stellar arrangement, ensuring those who knew where to look
would find protection against the dangers of deep space.

By mapping this constellation, your ship can now generate a protective field that reduces damage from space anomalies and debris.
''',
      ability: UnlockableAbility(
        name: 'Stellar Shield',
        description: 'Ship takes 40% less damage from anomalies',
        type: AbilityType.enhancedShielding,
        value: 0.6,
      ),
      regionUnlocked: 'Polar Expanse',
    ),
    'Scorpius': ConstellationStory(
      name: 'Scorpius',
      title: 'The Stinger\'s Thrust',
      story: '''
The curved tail of Scorpius contains secrets of propulsion technology far beyond your current understanding. The ancient space-faring 
civilization that mapped these stars discovered that mimicking the energy flow pattern of this constellation could dramatically 
improve thruster efficiency.

The "stinger" stars of Scorpius hold the key to quick directional changes and efficient acceleration - critical for both predator and prey
in the cosmic ecosystem.

With this constellation mapped, your engines can now produce more thrust with the same energy input, improving your maneuverability in tight situations.
''',
      ability: UnlockableAbility(
        name: 'Scorpion Sting',
        description: 'Engine thrust increased by 45%',
        type: AbilityType.improvedThrust,
        value: 1.45,
      ),
      regionUnlocked: 'Antares Sector',
    ),
    'Orion': ConstellationStory(
      name: 'Orion',
      title: 'The Hunter\'s Path',
      story: '''
Orion the Hunter strides eternally across the night sky, both on Earth and now in your journeys through space. What was once merely
a mythology has revealed itself to be something far more significant - a map to the secret pathways between the stars.

The three stars of Orion's belt align perfectly with ancient wormhole generators placed by a civilization lost to time. By mapping this
constellation completely, you've unlocked the ability to detect and safely navigate these hidden passages.

This discovery revolutionizes your ability to cover vast distances, though the wormholes themselves remain unpredictable and should be
approached with caution.
''',
      ability: UnlockableAbility(
        name: 'Wormhole Mastery',
        description: 'Ability to detect and navigate through wormholes safely',
        type: AbilityType.wormholeNavigation,
        value: 1.0,
      ),
      regionUnlocked: 'Orion Arm',
    ),
    'Lyra': ConstellationStory(
      name: 'Lyra',
      title: 'The Harmonious Energy',
      story: '''
The Lyra constellation, shaped like the ancient stringed instrument, contains a profound secret about energy harmonics. The precise
arrangement of these stars demonstrates principles of wave resonance that can be applied to your ship's power systems.

Ancient texts speak of "the music of the spheres" - what was once thought to be mere poetry has proven to be a sophisticated
understanding of how energy flows through the cosmos.

With Lyra mapped, your ship can now generate power more efficiently by harmonizing its energy systems with these cosmic principles.
Your fuel reserves will last significantly longer on your journey through the stars.
''',
      ability: UnlockableAbility(
        name: 'Cosmic Harmony',
        description: 'Fuel efficiency increased by 50%',
        type: AbilityType.increasedFuel,
        value: 1.5,
      ),
      regionUnlocked: 'Vega Sector',
    ),
    'Cygnus': ConstellationStory(
      name: 'Cygnus',
      title: 'The Cosmic Swan\'s Grace',
      story: '''
The Cygnus constellation, shaped like a swan in flight, reveals secrets about moving through space with minimal resistance.
The swan has long been a symbol of grace and efficiency of movement, and the stellar arrangement reflects advanced principles
of aerodynamics that apply even in the vacuum of space.

By studying the energy flows between these stars, your ship's computer has developed new algorithms for navigating around cosmic
obstacles, reducing the impact of turbulence from anomalies and gravitational disturbances.

Your ship now moves with greater precision through difficult regions, allowing you to safely explore more dangerous areas of space.
''',
      ability: UnlockableAbility(
        name: 'Swan\'s Grace',
        description: 'Movement through anomalies improved by 60%',
        type: AbilityType.enhancedShielding,
        value: 0.4,
      ),
      regionUnlocked: 'Northern Cross',
    ),
  };

  /// Get the story for a specific constellation
  static ConstellationStory getStory(String constellation) {
    if (!_stories.containsKey(constellation)) {
      // Default story if not found
      return ConstellationStory(
        name: constellation,
        title: 'An Undocumented Discovery',
        story:
            'This constellation is not yet documented in your database. By mapping it, you\'ve contributed valuable data to astronomers across the galaxy.',
        ability: null,
        regionUnlocked: '',
      );
    }
    return _stories[constellation]!;
  }

  /// Get all constellation stories
  static List<ConstellationStory> getAllStories() {
    return _stories.values.toList();
  }
}

/// Represents a story about a constellation and what it unlocks
class ConstellationStory {
  final String name;
  final String title;
  final String story;
  final UnlockableAbility? ability;
  final String regionUnlocked;

  ConstellationStory({
    required this.name,
    required this.title,
    required this.story,
    this.ability,
    this.regionUnlocked = '',
  });
}
