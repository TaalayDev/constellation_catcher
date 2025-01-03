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

  ConstellationInfo copyWith({
    String? name,
    String? mythology,
    String? bestViewing,
    String? brightestStar,
    String? magnitude,
    String? distance,
    List<String>? funFacts,
    String? visibleFrom,
    List<CulturalSignificance>? culturalSignificance,
    List<StarInfo>? mainStars,
    String? historicalBackground,
    List<String>? observationTips,
  }) {
    return ConstellationInfo(
      name: name ?? this.name,
      mythology: mythology ?? this.mythology,
      bestViewing: bestViewing ?? this.bestViewing,
      brightestStar: brightestStar ?? this.brightestStar,
      magnitude: magnitude ?? this.magnitude,
      distance: distance ?? this.distance,
      funFacts: funFacts ?? this.funFacts,
      visibleFrom: visibleFrom ?? this.visibleFrom,
      culturalSignificance: culturalSignificance ?? this.culturalSignificance,
      mainStars: mainStars ?? this.mainStars,
      historicalBackground: historicalBackground ?? this.historicalBackground,
      observationTips: observationTips ?? this.observationTips,
    );
  }
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

    // New constellations...
    'Lyra': ConstellationInfo(
      name: 'Lyra',
      mythology:
          'Named after the lyre of Orpheus in Greek mythology, this constellation is associated with the musician and poet.',
      bestViewing: 'Summer months in Northern Hemisphere',
      brightestStar: 'Vega (Alpha Lyrae)',
      magnitude: '0.03',
      distance: '25 light-years',
      funFacts: [
        'Contains the fifth-brightest star in the sky, Vega',
        'Site of the Ring Nebula (M57), a planetary nebula',
        'Used for navigation by ancient mariners',
        'One of the 48 constellations listed by Ptolemy'
      ],
      visibleFrom: 'Visible year-round from most of the world',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'Greek',
            interpretation:
                'Associated with the lyre of Orpheus, the musician and poet'),
        CulturalSignificance(
            culture: 'Native American',
            interpretation:
                'Associated with the eagle, a symbol of strength and power')
      ],
      mainStars: [
        StarInfo(
            name: 'Vega',
            designation: 'Alpha Lyrae',
            magnitude: '0.03',
            distance: '25 light-years',
            spectralType: 'A0V')
      ],
      historicalBackground:
          'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
      observationTips: [
        'Look for the bright star Vega',
        'Use it to find the Ring Nebula (M57)',
        'Best viewed during summer evenings',
        'Contains many bright stars and nebulae'
      ],
    ),
    'Cygnus': ConstellationInfo(
      name: 'Cygnus',
      mythology:
          'Named after the swan in Greek mythology, this constellation is associated with several myths and legends.',
      bestViewing: 'Summer months in Northern Hemisphere',
      brightestStar: 'Deneb (Alpha Cygni)',
      magnitude: '1.25',
      distance: '1,500 light-years',
      funFacts: [
        'Contains the Northern Cross asterism',
        'Site of the North America Nebula (NGC 7000)',
        'Used for navigation by ancient mariners',
        'One of the 48 constellations listed by Ptolemy'
      ],
      visibleFrom: 'Visible year-round from most of the world',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'Greek',
            interpretation:
                'Associated with the swan Zeus transformed into to seduce Leda'),
        CulturalSignificance(
            culture: 'Native American',
            interpretation:
                'Associated with the eagle, a symbol of strength and power')
      ],
      mainStars: [
        StarInfo(
            name: 'Deneb',
            designation: 'Alpha Cygni',
            magnitude: '1.25',
            distance: '1,500 light-years',
            spectralType: 'A2Ia')
      ],
      historicalBackground:
          'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
      observationTips: [
        'Look for the Northern Cross asterism',
        'Use it to find the North America Nebula (NGC 7000)',
        'Best viewed during summer evenings',
        'Contains many bright stars and nebulae'
      ],
    ),
    'Perseus': ConstellationInfo(
      name: 'Perseus',
      mythology:
          'Named after the hero in Greek mythology, this constellation is associated with the slaying of the Gorgon Medusa.',
      bestViewing: 'Winter months in Northern Hemisphere',
      brightestStar: 'Mirfak (Alpha Persei)',
      magnitude: '1.79',
      distance: '590 light-years',
      funFacts: [
        'Contains the famous Double Cluster (NGC 869 and NGC 884)',
        'Site of the Perseus Cluster of galaxies (Abell 426)',
        'Used for navigation by ancient mariners',
        'One of the 48 constellations listed by Ptolemy'
      ],
      visibleFrom: 'Visible year-round from most of the world',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'Greek',
            interpretation:
                'Associated with the hero Perseus, who slew the Gorgon Medusa'),
        CulturalSignificance(
            culture: 'Native American',
            interpretation:
                'Associated with the eagle, a symbol of strength and power')
      ],
      mainStars: [
        StarInfo(
            name: 'Mirfak',
            designation: 'Alpha Persei',
            magnitude: '1.79',
            distance: '590 light-years',
            spectralType: 'F5Ib')
      ],
      historicalBackground:
          'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
      observationTips: [
        'Look for the bright star Mirfak',
        'Use it to find the Double Cluster (NGC 869 and NGC 884)',
        'Best viewed during winter evenings',
        'Contains many bright stars and nebulae'
      ],
    ),
    'Pegasus': ConstellationInfo(
      name: 'Pegasus',
      mythology:
          'Named after the winged horse in Greek mythology, this constellation is associated with several myths and legends.',
      bestViewing: 'Autumn months in Northern Hemisphere',
      brightestStar: 'Scheat (Beta Pegasi)',
      magnitude: '2.42',
      distance: '196 light-years',
      funFacts: [
        'Contains the Great Square of Pegasus asterism',
        'Site of the Andromeda Galaxy (M31)',
        'Used for navigation by ancient mariners',
        'One of the 48 constellations listed by Ptolemy'
      ],
      visibleFrom: 'Visible year-round from most of the world',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'Greek',
            interpretation:
                'Associated with the winged horse Pegasus, who sprang from the blood of Medusa'),
        CulturalSignificance(
            culture: 'Native American',
            interpretation:
                'Associated with the eagle, a symbol of strength and power')
      ],
      mainStars: [
        StarInfo(
            name: 'Scheat',
            designation: 'Beta Pegasi',
            magnitude: '2.42',
            distance: '196 light-years',
            spectralType: 'M2.5II-III')
      ],
      historicalBackground:
          'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
      observationTips: [
        'Look for the Great Square of Pegasus',
        'Use it to find the Andromeda Galaxy (M31)',
        'Best viewed during autumn evenings',
        'Contains many bright stars and nebulae'
      ],
    ),
    'Gemini': ConstellationInfo(
      name: 'Gemini',
      mythology:
          'Named after the twins Castor and Pollux in Greek mythology, this constellation is associated with several myths and legends.',
      bestViewing: 'Winter months in Northern Hemisphere',
      brightestStar: 'Pollux (Beta Geminorum)',
      magnitude: '1.14',
      distance: '34 light-years',
      funFacts: [
        'Contains the famous asterism "The Twins"',
        'Site of the Eskimo Nebula (NGC 2392)',
        'Used for navigation by ancient mariners',
        'One of the 48 constellations listed by Ptolemy'
      ],
      visibleFrom: 'Visible year-round from most of the world',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'Greek',
            interpretation:
                'Associated with the twins Castor and Pollux, who were placed in the stars after their deaths'),
        CulturalSignificance(
            culture: 'Native American',
            interpretation:
                'Associated with the eagle, a symbol of strength and power')
      ],
      mainStars: [
        StarInfo(
            name: 'Pollux',
            designation: 'Beta Geminorum',
            magnitude: '1.14',
            distance: '34 light-years',
            spectralType: 'K0III')
      ],
      historicalBackground:
          'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
      observationTips: [
        'Look for the bright stars Castor and Pollux',
        'Use them to find the Eskimo Nebula (NGC 2392)',
        'Best viewed during winter evenings',
        'Contains many bright stars and nebulae'
      ],
    ),
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

    // New levels...
    ConstellationLevel(
      name: "Lyra",
      requiredScore: 1750,
      starPositions: const [
        Offset(0.68, 1.07 / 2 - 0.5),
        Offset(0.55, 1.39 / 2 - 0.5),
        Offset(0.37, 1.61 / 2 - 0.5),
        Offset(0.34, 2.39 / 2 - 0.5),
        Offset(0.52, 2.22 / 2 - 0.5),
      ],
      connections: const [
        [0, 1],
        [1, 2],
        [2, 3],
        [3, 4],
        [4, 1],
      ],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: "Cygnus",
      requiredScore: 2200,
      starPositions: const [
        Offset(0.53, 0.205),
        Offset(0.61, 0.335),
        Offset(0.74, 0.49),
        Offset(0.90, 0.67),
        Offset(0.93, 0.025),
        Offset(0.87, 0.07),
        Offset(0.81, 0.235),
        Offset(0.45, 0.495),
        Offset(0.27, 0.555),
        Offset(0.07, 0.545),
      ],
      connections: const [
        [0, 1],
        [1, 2],
        [2, 3],
        [4, 5],
        [5, 6],
        [6, 1],
        [1, 7],
        [7, 8],
        [8, 9],
      ],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: "Perseus",
      requiredScore: 2500,
      starPositions: const [
        Offset(0.52, 0),
        Offset(0.48, 0.06),
        Offset(0.52, 0.07),
        Offset(0.41, 0.16),
        Offset(0.47, 0.165),
        Offset(0.58, 0.155),
        Offset(0.67, 0.12),
        Offset(0.83, 0.05),
        Offset(0.32, 0.215),
        Offset(0.20, 0.225),
        Offset(0.17, 0.2),
        Offset(0.16, 0.15),
        Offset(0.22, 0.15),
        Offset(0.24, 0.405),
        Offset(0.51, 0.37),
        Offset(0.53, 0.42),
        Offset(0.23, 0.515),
        Offset(0.26, 0.61),
        Offset(0.32, 0.6),
      ],
      connections: const [
        [0, 1],
        [1, 3],
        [3, 8],
        [8, 9],
        [9, 10],
        [10, 11],
        [11, 12],
        [0, 2],
        [2, 4],
        [4, 5],
        [5, 6],
        [6, 7],
        [4, 3],
        [8, 13],
        [4, 14],
        [14, 15],
        [14, 13],
        [13, 16],
        [16, 17],
        [17, 18],
      ],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: "Pegasus",
      requiredScore: 2800,
      starPositions: const [
        Offset(0.17, 0.18),
        Offset(0.46, 0.20),
        Offset(0.46, 0.45),
        Offset(0.11, 0.44),
        Offset(0.55, 0.16),
        Offset(0.69, 0.09),
        Offset(0.53, 0.27),
        Offset(0.55, 0.30),
        Offset(0.74, 0.25),
        Offset(0.84, 0.23),
        Offset(0.55, 0.50),
        Offset(0.59, 0.53),
        Offset(0.75, 0.61),
        Offset(0.89, 0.53),
      ],
      connections: const [
        [0, 1],
        [1, 2],
        [2, 3],
        [3, 0],
        [1, 4],
        [4, 5],
        [1, 6],
        [6, 7],
        [7, 8],
        [8, 9],
        [2, 10],
        [10, 11],
        [11, 12],
        [12, 13],
      ],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: "Gemini",
      requiredScore: 3000,
      starPositions: const [
        Offset(0.27, 0.10),
        Offset(0.43, 0.15),
        Offset(0.56, 0.04),
        Offset(0.33, 0.22),
        Offset(0.63, 0.30),
        Offset(0.80, 0.36),
        Offset(0.87, 0.36),
        Offset(0.95, 0.32),
        Offset(0.76, 0.43),
        Offset(0.18, 0.20),
        Offset(0.25, 0.24),
        Offset(0.18, 0.31),
        Offset(0.36, 0.39),
        Offset(0.38, 0.55),
        Offset(0.64, 0.65),
        Offset(0.49, 0.43),
        Offset(0.70, 0.54),
      ],
      connections: const [
        [0, 1],
        [1, 2],
        [1, 3],
        [1, 4],
        [4, 8],
        [4, 5],
        [5, 6],
        [6, 7],
        [3, 10],
        [10, 9],
        [10, 11],
        [10, 12],
        [12, 13],
        [12, 15],
        [15, 16],
        [13, 14],
      ],
      isClosedLoop: false,
    ),

    // ConstellationLevel(
    //   name: 'Gemini',
    //   requiredScore: 3000,
    //   starPositions: const [
    //     Offset(0.40, 0.25), // Castor (Alpha Geminorum)
    //     Offset(0.45, 0.25), // Pollux (Beta Geminorum)
    //     Offset(0.35, 0.35), // Gamma Geminorum
    //     Offset(0.50, 0.35), // Delta Geminorum
    //     Offset(0.30, 0.45), // Epsilon Geminorum
    //     Offset(0.55, 0.45), // Zeta Geminorum
    //     Offset(0.40, 0.55), // Eta Geminorum
    //     Offset(0.45, 0.55), // Mu Geminorum
    //   ],
    //   connections: const [
    //     [0, 1], // Castor to Pollux
    //     [0, 2], // Castor to Gamma
    //     [1, 3], // Pollux to Delta
    //     [2, 4], // Gamma to Epsilon
    //     [3, 5], // Delta to Zeta
    //     [4, 6], // Epsilon to Eta
    //     [5, 7], // Zeta to Mu
    //     [6, 7], // Eta to Mu
    //   ],
    //   isClosedLoop: false,
    // ),
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
