import 'package:flutter/material.dart';

import '../models/constellation_level.dart';

class ConstellationInfo {
  final String name;
  final String mythology;
  final String bestViewing;
  final String brightestStar;
  final String magnitude;
  final String distance;
  final List<String> funFacts;
  final String visibleFrom;
  final List<CulturalSignificance> culturalSignificance;
  final List<StarInfo> mainStars;
  final String historicalBackground;
  final List<String> observationTips;

  ConstellationInfo({
    required this.name,
    required this.mythology,
    required this.bestViewing,
    required this.brightestStar,
    required this.magnitude,
    required this.distance,
    required this.funFacts,
    required this.visibleFrom,
    required this.culturalSignificance,
    required this.mainStars,
    required this.historicalBackground,
    required this.observationTips,
  });
}

class CulturalSignificance {
  final String culture;
  final String interpretation;

  CulturalSignificance({
    required this.culture,
    required this.interpretation,
  });
}

class StarInfo {
  final String name;
  final String designation;
  final String magnitude;
  final String distance;
  final String spectralType;

  StarInfo({
    required this.name,
    required this.designation,
    required this.magnitude,
    required this.distance,
    required this.spectralType,
  });
}

// Constellation data service
class ConstellationDataService {
  static final Map<String, ConstellationInfo> _constellations = {
    'Triangulum': ConstellationInfo(
      name: 'Triangulum',
      mythology:
          'Named after its triangular shape, this constellation has no known mythological significance.',
      bestViewing: 'Autumn months in Northern Hemisphere',
      brightestStar: 'Beta Trianguli',
      magnitude: '3.00',
      distance: '63 light-years',
      funFacts: [
        'One of the 48 constellations listed by Ptolemy',
        'Contains the Triangulum Galaxy (M33)',
        'The constellation is circumpolar from most of Europe and North America'
      ],
      visibleFrom: 'Visible year-round from Northern Hemisphere',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'Ancient Greek',
            interpretation:
                'Associated with the triangle, a symbol of the number three in ancient mathematics')
      ],
      mainStars: [
        StarInfo(
            name: 'Beta Trianguli',
            designation: 'Beta Trianguli',
            magnitude: '3.00',
            distance: '63 light-years',
            spectralType: 'A5V')
      ],
      historicalBackground:
          'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
      observationTips: [
        'Look for the distinctive triangle shape',
        'Use it to find the Andromeda Galaxy',
        'Best viewed during autumn evenings',
        'Contains the Triangulum Galaxy (M33)'
      ],
    ),

    'Ursa Minor': ConstellationInfo(
      name: 'Ursa Minor',
      mythology:
          'Named after the Little Bear, this constellation is associated with the nymph Callisto in Greek mythology. Zeus transformed her into a bear and placed her among the stars.',
      bestViewing: 'Spring months in Northern Hemisphere',
      brightestStar: 'Polaris (Alpha Ursae Minoris)',
      magnitude: '1.97',
      distance: '433 light-years',
      funFacts: [
        'Contains the North Star, Polaris',
        'Used for navigation by many cultures',
        'The Little Dipper is part of this constellation',
        'Polaris has been used for navigation for thousands of years'
      ],
      visibleFrom: 'Visible year-round from most of Northern Hemisphere',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'Ancient Greek',
            interpretation:
                'Zeus transformed Callisto into a bear and placed her in the stars to protect her from Hera\'s wrath.'),
        CulturalSignificance(
            culture: 'Native American',
            interpretation:
                'Associated with the Great Bear, which is hunted through the seasons')
      ],
      mainStars: [
        StarInfo(
            name: 'Polaris',
            designation: 'Alpha Ursae Minoris',
            magnitude: '1.97',
            distance: '433 light-years',
            spectralType: 'F7Ib')
      ],
      historicalBackground:
          'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
      observationTips: [
        'Use the two stars at the end of the bowl of the Big Dipper to find Polaris',
        'Polaris is the last star in the handle of the Little Dipper',
        'The Little Dipper is part of Ursa Minor',
        'Polaris is the North Star and does not move in the sky'
      ],
    ),

    'Ursa Major': ConstellationInfo(
      name: 'Ursa Major',
      mythology:
          'Known as the Great Bear, this constellation is associated with the nymph Callisto in Greek mythology. Zeus transformed her into a bear and placed her among the stars.',
      bestViewing: 'Spring months in Northern Hemisphere',
      brightestStar: 'Alioth (Epsilon Ursae Majoris)',
      magnitude: '1.76',
      distance: '81 light-years',
      funFacts: [
        'Contains the famous asterism "The Big Dipper"',
        'One of the oldest documented constellations',
        'Used for navigation for thousands of years',
        'Contains multiple galaxies visible with amateur telescopes',
        'The stars of the Big Dipper are actually moving through space together as a group'
      ],
      visibleFrom: 'Visible year-round from most of Northern Hemisphere',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'Native American',
            interpretation:
                'Many tribes saw it as a great bear being hunted through the seasons, with the hunt explaining why the bear rises in spring and falls in autumn.'),
        CulturalSignificance(
            culture: 'Ancient Greek',
            interpretation:
                'Zeus transformed Callisto into a bear and placed her in the stars to protect her from Hera\'s wrath.'),
        CulturalSignificance(
            culture: 'Chinese',
            interpretation:
                'Part of the Northern Dipper, associated with the Taoist deity Tian Huang Da Di and used in feng shui.')
      ],
      mainStars: [
        StarInfo(
            name: 'Alioth',
            designation: 'Epsilon Ursae Majoris',
            magnitude: '1.76',
            distance: '81 light-years',
            spectralType: 'A0p'),
        StarInfo(
            name: 'Dubhe',
            designation: 'Alpha Ursae Majoris',
            magnitude: '1.79',
            distance: '124 light-years',
            spectralType: 'K0III')
      ],
      historicalBackground:
          'First cataloged by Ptolemy in the 2nd century AD, Ursa Major has been recognized by cultures around the world for thousands of years.',
      observationTips: [
        'Best viewed during spring evenings in the Northern Hemisphere',
        'Use the pointer stars Dubhe and Merak to find Polaris',
        'Look for the galaxy M81 near the bear\'s head',
        'The constellation is circumpolar from most of Europe and North America'
      ],
    ),

    'Scorpius': ConstellationInfo(
      name: 'Scorpius',
      mythology:
          'Named after the scorpion in Greek mythology that stung Orion, the hunter. Orion and Scorpius are on opposite sides of the sky and are never visible at the same time.',
      bestViewing: 'Summer months in Southern Hemisphere',
      brightestStar: 'Antares (Alpha Scorpii)',
      magnitude: '0.96',
      distance: '550 light-years',
      funFacts: [
        'Contains the red supergiant star Antares',
        'One of the zodiac constellations',
        'Used for navigation by ancient mariners',
        'Contains the Butterfly Cluster (M6) and the Ptolemy Cluster (M7)'
      ],
      visibleFrom: 'Visible year-round from Southern Hemisphere',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'Ancient Greek',
            interpretation:
                'Associated with the scorpion that stung Orion, the hunter'),
        CulturalSignificance(
            culture: 'Babylonian',
            interpretation:
                'Associated with the scorpion goddess Ishhara, protector of the dead')
      ],
      mainStars: [
        StarInfo(
            name: 'Antares',
            designation: 'Alpha Scorpii',
            magnitude: '0.96',
            distance: '550 light-years',
            spectralType: 'M1Iab-b')
      ],
      historicalBackground:
          'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
      observationTips: [
        'Look for the distinctive curved shape of the scorpion',
        'Use the stars of Scorpius to find the planets Jupiter and Saturn',
        'Best viewed during summer evenings in the Southern Hemisphere',
        'Contains many bright star clusters and nebulae'
      ],
    ),

    'Cassiopeia': ConstellationInfo(
      name: 'Cassiopeia',
      mythology:
          'Named after the vain queen Cassiopeia in Greek mythology, who boasted that her beauty surpassed that of the sea nymphs.',
      bestViewing: 'Autumn months in Northern Hemisphere',
      brightestStar: 'Schedar (Alpha Cassiopeiae)',
      magnitude: '2.24',
      distance: '228 light-years',
      funFacts: [
        'Forms a distinctive W or M shape in the sky',
        'Contains several bright star clusters',
        'Site of a famous supernova in 1572',
        'Never sets below the horizon in most of North America'
      ],
      visibleFrom: 'Visible year-round from Northern Hemisphere',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'Greek',
            interpretation:
                'The queen was placed in the stars as punishment, forced to circle the celestial pole forever'),
        CulturalSignificance(
            culture: 'Chinese',
            interpretation:
                'Known as the Sky Palace, associated with imperial authority')
      ],
      mainStars: [
        StarInfo(
            name: 'Schedar',
            designation: 'Alpha Cassiopeiae',
            magnitude: '2.24',
            distance: '228 light-years',
            spectralType: 'K0II')
      ],
      historicalBackground:
          'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
      observationTips: [
        'Look for the distinctive W or M shape',
        'Use it to find the Andromeda Galaxy',
        'Best viewed during autumn evenings',
        'Contains many bright star clusters for telescope viewing'
      ],
    ),

    'Orion': ConstellationInfo(
      name: 'Orion',
      mythology:
          'Named after the hunter in Greek mythology, this constellation is one of the most recognizable in the night sky.',
      bestViewing: 'Winter months in Northern Hemisphere',
      brightestStar: 'Rigel (Beta Orionis)',
      magnitude: '0.18',
      distance: '860 light-years',
      funFacts: [
        'Contains the famous asterism "The Belt of Orion"',
        'Site of the Orion Nebula (M42), a stellar nursery',
        'Used for navigation by many cultures',
        'Orion is mentioned in the Bible and other ancient texts'
      ],
      visibleFrom: 'Visible year-round from most of the world',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'Ancient Greek',
            interpretation:
                'Associated with the hunter Orion, who was placed in the stars after his death'),
        CulturalSignificance(
            culture: 'Egyptian',
            interpretation:
                'Associated with Osiris, god of the afterlife and rebirth')
      ],
      mainStars: [
        StarInfo(
            name: 'Rigel',
            designation: 'Beta Orionis',
            magnitude: '0.18',
            distance: '860 light-years',
            spectralType: 'B8Ia'),
        StarInfo(
            name: 'Betelgeuse',
            designation: 'Alpha Orionis',
            magnitude: '0.45',
            distance: '640 light-years',
            spectralType: 'M1Iab')
      ],
      historicalBackground:
          'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
      observationTips: [
        'Look for the distinctive Belt of Orion',
        'Use it to find the Orion Nebula (M42)',
        'Best viewed during winter evenings',
        'Contains many bright stars and nebulae'
      ],
    ),
    // Add more constellations...
  };

  static final List<ConstellationLevel> levels = [
    ConstellationLevel(
      name: 'Triangulum',
      requiredScore: 500,
      starPositions: const [
        Offset(0.45, 0.40), // Alpha Trianguli
        Offset(0.55, 0.40), // Beta Trianguli
        Offset(0.50, 0.25), // Gamma Trianguli
      ],
      connections: const [
        [0, 1], // Alpha to Beta
        [1, 2], // Beta to Gamma
        [2, 0], // Gamma to Alpha
      ],
      isClosedLoop: true,
    ),
    ConstellationLevel(
      name: 'Cassiopeia',
      requiredScore: 1000,
      starPositions: const [
        Offset(0.30, 0.35), // Alpha Cas (Schedar)
        Offset(0.40, 0.25), // Beta Cas (Caph)
        Offset(0.50, 0.35), // Gamma Cas (Tsih)
        Offset(0.60, 0.25), // Delta Cas (Ruchbah)
        Offset(0.70, 0.35), // Epsilon Cas (Segin)
      ],
      connections: const [
        [0, 1],
        [1, 2],
        [2, 3],
        [3, 4],
      ],
      isClosedLoop: false,
    ),
    ConstellationLevel(
      name: 'Ursa Minor',
      requiredScore: 1500,
      starPositions: const [
        Offset(0.50, 0.20), // Polaris (North Star)
        Offset(0.45, 0.25), // Kochab
        Offset(0.55, 0.25), // Pherkad
        Offset(0.48, 0.30), // Epsilon UMi
        Offset(0.52, 0.35), // Zeta UMi
        Offset(0.50, 0.40), // Eta UMi
      ],
      connections: const [
        [2, 3],
        [0, 2],
        [1, 0],
        [1, 3],
        [3, 4],
        [4, 5],
      ],
      isClosedLoop: false,
    ),
    ConstellationLevel(
      name: 'Scorpius',
      requiredScore: 2000,
      starPositions: const [
        Offset(0.30, 0.20), // Antares (Alpha Sco)
        Offset(0.35, 0.25), // Graffias (Beta Sco)
        Offset(0.40, 0.30), // Delta Sco
        Offset(0.45, 0.35), // Pi Sco
        Offset(0.50, 0.40), // Sigma Sco
        Offset(0.55, 0.45), // Tau Sco
        Offset(0.60, 0.50), // Shaula (Lambda Sco)
        Offset(0.55, 0.55), // Lesath (Upsilon Sco)
        Offset(0.25, 0.25), // Nu Sco
        Offset(0.45, 0.25), // Rho Sco
      ],
      connections: const [
        [0, 1],
        [1, 2],
        [2, 3],
        [3, 4],
        [4, 5],
        [5, 6],
        [6, 7],
        [0, 8],
        [0, 9],
      ],
      isClosedLoop: false,
    ),
    ConstellationLevel(
      name: 'Orion',
      requiredScore: 1500,
      starPositions: const [
        Offset(0.45, 0.25), // Betelgeuse (Alpha Ori)
        Offset(0.55, 0.25), // Bellatrix (Gamma Ori)
        Offset(0.50, 0.35), // Alnilam (Epsilon Ori - center belt)
        Offset(0.45, 0.35), // Alnitak (Zeta Ori - left belt)
        Offset(0.55, 0.35), // Mintaka (Delta Ori - right belt)
        Offset(0.40, 0.45), // Saiph (Kappa Ori)
        Offset(0.60, 0.45), // Rigel (Beta Ori)
      ],
      connections: const [
        [0, 1], // Betelgeuse to Bellatrix (shoulders)
        [3, 2], // Belt stars: left to center
        [2, 4], // Belt stars: center to right
        [0, 3], // Betelgeuse to left belt
        [1, 4], // Bellatrix to right belt
        [3, 5], // Left belt to Saiph
        [4, 6], // Right belt to Rigel
        [5, 6], // Saiph to Rigel (feet)
      ],
      isClosedLoop: false,
    ),
  ];

  static ConstellationInfo getConstellationInfo(String name) {
    if (!_constellations.containsKey(name)) {
      throw ArgumentError('Constellation $name not found');
    }
    return _constellations[name]!;
  }

  static List<String> getAllConstellationNames() {
    return _constellations.keys.toList();
  }
}
