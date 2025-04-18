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
  static final Map<String, ConstellationInfo> constellations = {
    'Triangulum': ConstellationInfo(
      name: 'Triangulum',
      mythology: 'Named after its triangular shape, this constellation has no known mythological significance.',
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
            interpretation: 'Associated with the triangle, a symbol of the number three in ancient mathematics')
      ],
      mainStars: [
        StarInfo(
            name: 'Beta Trianguli',
            designation: 'Beta Trianguli',
            magnitude: '3.00',
            distance: '63 light-years',
            spectralType: 'A5V')
      ],
      historicalBackground: 'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
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
            interpretation: 'Associated with the Great Bear, which is hunted through the seasons')
      ],
      mainStars: [
        StarInfo(
            name: 'Polaris',
            designation: 'Alpha Ursae Minoris',
            magnitude: '1.97',
            distance: '433 light-years',
            spectralType: 'F7Ib')
      ],
      historicalBackground: 'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
      observationTips: [
        'Use the two stars at the end of the bowl of the Big Dipper to find Polaris',
        'Polaris is the last star in the handle of the Little Dipper',
        'The Little Dipper is part of Ursa Minor',
        'Polaris is the North Star and does not move in the sky'
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
            culture: 'Ancient Greek', interpretation: 'Associated with the scorpion that stung Orion, the hunter'),
        CulturalSignificance(
            culture: 'Babylonian',
            interpretation: 'Associated with the scorpion goddess Ishhara, protector of the dead')
      ],
      mainStars: [
        StarInfo(
            name: 'Antares',
            designation: 'Alpha Scorpii',
            magnitude: '0.96',
            distance: '550 light-years',
            spectralType: 'M1Iab-b')
      ],
      historicalBackground: 'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
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
            culture: 'Chinese', interpretation: 'Known as the Sky Palace, associated with imperial authority')
      ],
      mainStars: [
        StarInfo(
            name: 'Schedar',
            designation: 'Alpha Cassiopeiae',
            magnitude: '2.24',
            distance: '228 light-years',
            spectralType: 'K0II')
      ],
      historicalBackground: 'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
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
            interpretation: 'Associated with the hunter Orion, who was placed in the stars after his death'),
        CulturalSignificance(
            culture: 'Egyptian', interpretation: 'Associated with Osiris, god of the afterlife and rebirth')
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
      historicalBackground: 'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
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
            culture: 'Greek', interpretation: 'Associated with the lyre of Orpheus, the musician and poet'),
        CulturalSignificance(
            culture: 'Native American', interpretation: 'Associated with the eagle, a symbol of strength and power')
      ],
      mainStars: [
        StarInfo(
            name: 'Vega',
            designation: 'Alpha Lyrae',
            magnitude: '0.03',
            distance: '25 light-years',
            spectralType: 'A0V')
      ],
      historicalBackground: 'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
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
            culture: 'Greek', interpretation: 'Associated with the swan Zeus transformed into to seduce Leda'),
        CulturalSignificance(
            culture: 'Native American', interpretation: 'Associated with the eagle, a symbol of strength and power')
      ],
      mainStars: [
        StarInfo(
            name: 'Deneb',
            designation: 'Alpha Cygni',
            magnitude: '1.25',
            distance: '1,500 light-years',
            spectralType: 'A2Ia')
      ],
      historicalBackground: 'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
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
            culture: 'Greek', interpretation: 'Associated with the hero Perseus, who slew the Gorgon Medusa'),
        CulturalSignificance(
            culture: 'Native American', interpretation: 'Associated with the eagle, a symbol of strength and power')
      ],
      mainStars: [
        StarInfo(
            name: 'Mirfak',
            designation: 'Alpha Persei',
            magnitude: '1.79',
            distance: '590 light-years',
            spectralType: 'F5Ib')
      ],
      historicalBackground: 'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
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
            interpretation: 'Associated with the winged horse Pegasus, who sprang from the blood of Medusa'),
        CulturalSignificance(
            culture: 'Native American', interpretation: 'Associated with the eagle, a symbol of strength and power')
      ],
      mainStars: [
        StarInfo(
            name: 'Scheat',
            designation: 'Beta Pegasi',
            magnitude: '2.42',
            distance: '196 light-years',
            spectralType: 'M2.5II-III')
      ],
      historicalBackground: 'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
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
            culture: 'Native American', interpretation: 'Associated with the eagle, a symbol of strength and power')
      ],
      mainStars: [
        StarInfo(
            name: 'Pollux',
            designation: 'Beta Geminorum',
            magnitude: '1.14',
            distance: '34 light-years',
            spectralType: 'K0III')
      ],
      historicalBackground: 'One of the 48 constellations listed by Ptolemy in the 2nd century AD.',
      observationTips: [
        'Look for the bright stars Castor and Pollux',
        'Use them to find the Eskimo Nebula (NGC 2392)',
        'Best viewed during winter evenings',
        'Contains many bright stars and nebulae'
      ],
    ),

    'Ursa Major': ConstellationInfo(
        name: 'Ursa Major',
        mythology:
            'Represents the Great Bear. Most famously linked to the Greek myth of Callisto, a nymph turned into a bear by a jealous Hera (or Artemis) and placed in the sky by Zeus. Her son, Arcas, became Ursa Minor.',
        bestViewing: 'Spring months in Northern Hemisphere (circumpolar for many)',
        brightestStar: 'Alioth (Epsilon Ursae Majoris)',
        magnitude: '1.77',
        distance: '83 light-years',
        funFacts: [
          'Contains the famous "Big Dipper" (or "Plough") asterism.',
          'The third largest constellation in the sky.',
          'The stars Merak and Dubhe (the "Pointers") in the Big Dipper point towards Polaris (North Star).',
          'Many galaxies are visible within its boundaries, including M81, M82 (Bode\'s Galaxy and Cigar Galaxy), and M101 (Pinwheel Galaxy).'
        ],
        visibleFrom:
            'Visible year-round for most of the Northern Hemisphere (circumpolar north of ~40°N). Partially visible from northern parts of the Southern Hemisphere.',
        culturalSignificance: [
          CulturalSignificance(culture: 'Greek', interpretation: 'The Great Bear, associated with Callisto.'),
          CulturalSignificance(
              culture: 'Roman', interpretation: 'Known as Ursa Major (Great Bear) or Septentrio (Seven Plough Oxen).'),
          CulturalSignificance(
              culture: 'Native American (various)',
              interpretation: 'Often seen as a bear pursued by hunters (the handle stars).'),
          CulturalSignificance(
              culture: 'British/Irish', interpretation: 'Known as The Plough or Charles\' Wain (Wagon).'),
          CulturalSignificance(
              culture: 'Egyptian', interpretation: 'Associated with the "Thigh" or "Foreleg" of a bull.')
        ],
        mainStars: [
          StarInfo(
              name: 'Alioth',
              designation: 'ε UMa',
              magnitude: '1.77',
              distance: '83 light-years',
              spectralType: 'A1III-IVp'),
          StarInfo(
              name: 'Dubhe',
              designation: 'α UMa',
              magnitude: '1.79',
              distance: '123 light-years',
              spectralType: 'K0III + F0V'),
          StarInfo(
              name: 'Alkaid (Benetnasch)',
              designation: 'η UMa',
              magnitude: '1.86',
              distance: '104 light-years',
              spectralType: 'B3V'),
          StarInfo(
              name: 'Mizar',
              designation: 'ζ UMa',
              magnitude: '2.23 (visual double with Alcor)',
              distance: '83 light-years',
              spectralType: 'A2V + A2V + A1V'),
          StarInfo(
              name: 'Merak', designation: 'β UMa', magnitude: '2.37', distance: '80 light-years', spectralType: 'A1V'),
          StarInfo(
              name: 'Phecda (Phad)',
              designation: 'γ UMa',
              magnitude: '2.44',
              distance: '83 light-years',
              spectralType: 'A0Ve')
        ],
        historicalBackground:
            'One of the oldest recognized constellations, mentioned by Homer and listed by Ptolemy. Its distinct Big Dipper shape makes it universally known in the Northern Hemisphere.',
        observationTips: [
          'Easily find the Big Dipper asterism in the northern sky.',
          'Use the outer two stars of the Dipper\'s bowl (Merak and Dubhe) to draw a line pointing to Polaris.',
          'Follow the arc of the Dipper\'s handle to find Arcturus (Boötes) and then "spike" to Spica (Virgo).',
          'Look closely at Mizar (second star from the end of the handle) - good eyesight or binoculars reveal its companion Alcor.',
          'Explore the area around the Dipper with a telescope to find galaxies like M81 and M82.'
        ]),
    'Canis Major': ConstellationInfo(
        name: 'Canis Major',
        mythology:
            'Represents the "Greater Dog," often considered one of Orion the Hunter\'s hunting dogs (along with Canis Minor). It could also represent Laelaps, the fastest dog in the world, destined to always catch its prey.',
        bestViewing: 'Winter months in Northern Hemisphere, summer in Southern Hemisphere',
        brightestStar: 'Sirius (Alpha Canis Majoris)',
        magnitude: '-1.46',
        distance: '8.6 light-years',
        funFacts: [
          'Contains Sirius, the brightest star in the night sky.',
          'Sirius is also known as the "Dog Star."',
          'The ancient Egyptians based their calendar on the heliacal rising of Sirius.',
          'Home to the Canis Major Dwarf Galaxy, possibly the closest galaxy to the Milky Way.',
          'Contains the open cluster M41.'
        ],
        visibleFrom: 'Latitudes between +60° and -90°. Prominent in winter (N. Hemisphere) / summer (S. Hemisphere).',
        culturalSignificance: [
          CulturalSignificance(culture: 'Greek', interpretation: 'Orion\'s hunting dog or Laelaps.'),
          CulturalSignificance(culture: 'Roman', interpretation: 'Known as Canis Major (Greater Dog).'),
          CulturalSignificance(
              culture: 'Ancient Egyptian',
              interpretation: 'Sirius (Sopdet) was extremely important, heralding the Nile flood and the New Year.'),
          CulturalSignificance(culture: 'Chinese', interpretation: 'Sirius was Tiānláng (天狼), the Celestial Wolf.'),
          CulturalSignificance(culture: 'Polynesian', interpretation: 'Sirius was an important navigational star.')
        ],
        mainStars: [
          StarInfo(
              name: 'Sirius',
              designation: 'α CMa',
              magnitude: '-1.46',
              distance: '8.6 light-years',
              spectralType: 'A1V + DA2'),
          StarInfo(
              name: 'Adhara',
              designation: 'ε CMa',
              magnitude: '1.50',
              distance: '430 light-years',
              spectralType: 'B2II'),
          StarInfo(
              name: 'Wezen',
              designation: 'δ CMa',
              magnitude: '1.83',
              distance: '1,600 light-years',
              spectralType: 'F8Ia'),
          StarInfo(
              name: 'Mirzam',
              designation: 'β CMa',
              magnitude: '1.98 (variable)',
              distance: '500 light-years',
              spectralType: 'B1II-III'),
          StarInfo(
              name: 'Aludra',
              designation: 'η CMa',
              magnitude: '2.45',
              distance: '2,000 light-years',
              spectralType: 'B5Ia')
        ],
        historicalBackground: 'Recognized since antiquity due to the brilliance of Sirius. Listed by Ptolemy.',
        observationTips: [
          'Find Sirius by following the line of Orion\'s Belt downwards (Northern Hemisphere) or upwards (Southern Hemisphere).',
          'Sirius is unmistakably bright and often scintillates (twinkles) vigorously due to its brightness and low position for northern observers.',
          'The rest of the constellation forms the shape of a dog below and to the left of Sirius (Northern view).',
          'The open cluster M41 is located about 4 degrees south of Sirius, visible in binoculars.',
          'Best viewed during winter evenings.'
        ]),
    'Taurus': ConstellationInfo(
        name: 'Taurus',
        mythology:
            'Represents the Bull. Associated with several Greek myths: Zeus transforming into a bull to abduct Europa; the Cretan Bull captured by Heracles; or the bull encountered by Jason and the Argonauts.',
        bestViewing: 'Winter months in Northern Hemisphere',
        brightestStar: 'Aldebaran (Alpha Tauri)',
        magnitude: '0.86 (variable)',
        distance: '65 light-years',
        funFacts: [
          'One of the zodiac constellations.',
          'Aldebaran, a reddish giant star, represents the "eye" of the bull.',
          'Features two famous open star clusters: the Pleiades (M45) and the Hyades.',
          'The Hyades form the V-shape of the bull\'s face (Aldebaran is nearby but not physically part of the cluster).',
          'Contains the Crab Nebula (M1), a supernova remnant from 1054 AD.'
        ],
        visibleFrom: 'Latitudes between +90° and -65°. Prominent in the Northern Hemisphere winter sky.',
        culturalSignificance: [
          CulturalSignificance(culture: 'Greek', interpretation: 'The Bull (associated with Zeus, Cretan Bull, etc.).'),
          CulturalSignificance(culture: 'Roman', interpretation: 'Known as Taurus (The Bull).'),
          CulturalSignificance(culture: 'Babylonian', interpretation: 'Known as MUL.GU₄.AN.NA ("The Bull of Heaven").'),
          CulturalSignificance(culture: 'Egyptian', interpretation: 'Associated with a sacred bull.'),
          CulturalSignificance(
              culture: 'Norse', interpretation: 'Possibly linked to the mythology of the primeval cow Auðumbla.')
        ],
        mainStars: [
          StarInfo(
              name: 'Aldebaran',
              designation: 'α Tau',
              magnitude: '0.86 (variable)',
              distance: '65 light-years',
              spectralType: 'K5III'),
          StarInfo(
              name: 'Elnath (Alnath)',
              designation: 'β Tau',
              magnitude: '1.65',
              distance: '134 light-years',
              spectralType: 'B7III'),
          StarInfo(
              name: 'Hyadum I (Prima Hyadum)',
              designation: 'γ Tau',
              magnitude: '3.65',
              distance: '155 light-years',
              spectralType: 'G9.5III'),
          StarInfo(
              name: 'Ain (Oculus Boreus)',
              designation: 'ε Tau',
              magnitude: '3.53',
              distance: '147 light-years',
              spectralType: 'G9.5III'),
          StarInfo(
              name: 'Alcyone',
              designation: 'η Tau',
              magnitude: '2.87',
              distance: '440 light-years',
              spectralType: 'B7IIIe')
        ],
        historicalBackground:
            'A very ancient constellation, likely recognized in the Bronze Age. Its position along the ecliptic and association with the Pleiades made it significant. Listed by Ptolemy.',
        observationTips: [
          'Look for the V-shape of the Hyades cluster in the winter sky, with the bright reddish star Aldebaran nearby.',
          'Follow Orion\'s Belt upwards to find Aldebaran.',
          'The beautiful Pleiades cluster (M45), resembling a tiny dipper, is located "on the shoulder" of the bull.',
          'Use a telescope to find the Crab Nebula (M1) near the star Zeta Tauri (Tianguan).',
          'Taurus follows Aries and precedes Gemini along the ecliptic.'
        ]),
    'Leo': ConstellationInfo(
        name: 'Leo',
        mythology:
            'Represents the Lion, most often identified with the Nemean Lion, a fearsome beast killed by Heracles (Hercules) as the first of his Twelve Labors. The lion\'s hide was impenetrable, so Heracles had to strangle it.',
        bestViewing: 'Spring months in Northern Hemisphere',
        brightestStar: 'Regulus (Alpha Leonis)',
        magnitude: '1.36',
        distance: '79 light-years',
        funFacts: [
          'One of the zodiac constellations.',
          'Features a prominent asterism known as "The Sickle," resembling a backwards question mark, which forms the lion\'s head and mane.',
          'Regulus, meaning "Little King," lies almost exactly on the ecliptic path.',
          'The radiant point for the Leonid meteor shower (peaking mid-November) is in Leo.',
          'Home to many galaxies, including the Leo Triplet (M65, M66, NGC 3628).'
        ],
        visibleFrom: 'Latitudes between +90° and -65°. Prominent in the Northern Hemisphere spring sky.',
        culturalSignificance: [
          CulturalSignificance(culture: 'Greek', interpretation: 'The Nemean Lion killed by Heracles.'),
          CulturalSignificance(culture: 'Roman', interpretation: 'Known as Leo (The Lion).'),
          CulturalSignificance(culture: 'Babylonian', interpretation: 'Known as UR.GU.LA ("The Great Lion").'),
          CulturalSignificance(
              culture: 'Egyptian', interpretation: 'Associated with the power of the sun and pharaohs.'),
          CulturalSignificance(
              culture: 'Persian',
              interpretation: 'One of the four "Royal Stars," associated with the summer solstice millennia ago.')
        ],
        mainStars: [
          StarInfo(
              name: 'Regulus',
              designation: 'α Leo',
              magnitude: '1.36',
              distance: '79 light-years',
              spectralType: 'B7V'),
          StarInfo(
              name: 'Denebola',
              designation: 'β Leo',
              magnitude: '2.14',
              distance: '36 light-years',
              spectralType: 'A3Va'),
          StarInfo(
              name: 'Algieba',
              designation: 'γ Leo',
              magnitude: '2.08 (combined)',
              distance: '130 light-years',
              spectralType: 'K0III + G7III'),
          StarInfo(
              name: 'Zosma', designation: 'δ Leo', magnitude: '2.56', distance: '58 light-years', spectralType: 'A4V'),
          StarInfo(
              name: 'Chort (Coxa)',
              designation: 'θ Leo',
              magnitude: '3.32',
              distance: '165 light-years',
              spectralType: 'A2V')
        ],
        historicalBackground:
            'An ancient constellation of the zodiac, recognized by Mesopotamians, Egyptians, Greeks, and Romans. Its lion shape is relatively easy to discern.',
        observationTips: [
          'Look for the backwards question mark shape (The Sickle) in the spring sky.',
          'Regulus is the bright star at the bottom of the Sickle.',
          'Denebola marks the lion\'s tail, forming a triangle with Regulus and Arcturus (or Spica).',
          'Leo follows Cancer and precedes Virgo along the ecliptic.',
          'Use a telescope to hunt for galaxies like the Leo Triplet (M65, M66, NGC 3628) between Chort and Iota Leonis.'
        ]),
    'Andromeda': ConstellationInfo(
        name: 'Andromeda',
        mythology:
            'Named after the princess Andromeda in Greek mythology, daughter of King Cepheus and Queen Cassiopeia. She was chained to a rock as a sacrifice to the sea monster Cetus but was rescued by the hero Perseus.',
        bestViewing: 'Autumn months in Northern Hemisphere',
        brightestStar: 'Alpheratz (Alpha Andromedae)',
        magnitude: '2.06',
        distance: '97 light-years',
        funFacts: [
          'Home to the Andromeda Galaxy (M31), the nearest large spiral galaxy to the Milky Way and visible to the naked eye.',
          'Alpheratz forms one corner of the Great Square of Pegasus.',
          'Contains the Blue Snowball Nebula (NGC 7662), a planetary nebula.',
          'Associated with the Andromedids meteor shower (now weak).'
        ],
        visibleFrom: 'Latitudes between +90° and -40°. Prominent in the Northern Hemisphere autumn sky.',
        culturalSignificance: [
          CulturalSignificance(culture: 'Greek', interpretation: 'The chained princess Andromeda.'),
          CulturalSignificance(
              culture: 'Roman', interpretation: 'Known as Andromeda or Mulier Catenata (Chained Woman).'),
          CulturalSignificance(
              culture: 'Arabic',
              interpretation:
                  'Alpheratz comes from "surrat al-faras" (navel of the horse), linking it originally to Pegasus. Mirach comes from "mizar" (girdle).'),
          CulturalSignificance(
              culture: 'Chinese',
              interpretation:
                  'Stars incorporated into various asterisms, including Kui宿 (Legs/Striding) and Tian Dà Jiāngjūn (Heaven\'s Great General).')
        ],
        mainStars: [
          StarInfo(
              name: 'Alpheratz (Sirrah)',
              designation: 'α And',
              magnitude: '2.06',
              distance: '97 light-years',
              spectralType: 'B8IVpMnHg'),
          StarInfo(
              name: 'Mirach',
              designation: 'β And',
              magnitude: '2.05 (variable)',
              distance: '197 light-years',
              spectralType: 'M0III'),
          StarInfo(
              name: 'Almach',
              designation: 'γ And',
              magnitude: '2.17 (combined)',
              distance: '350 light-years',
              spectralType: 'K3IIb + B9.5V + B9.5V'),
          StarInfo(
              name: 'Sadiradra (Adhil)',
              designation: 'δ And',
              magnitude: '3.28',
              distance: '105 light-years',
              spectralType: 'K3III')
        ],
        historicalBackground:
            'One of Ptolemy\'s 48 constellations, part of the Perseus family of constellations linked by the Greek myth.',
        observationTips: [
          'Find the Great Square of Pegasus. Alpheratz is the corner opposite Scheat (Beta Peg).',
          'Extend a line from Alpheratz through Mirach (Beta And).',
          'From Mirach, "hop" up towards Mu Andromedae, then slightly further up again to find the faint fuzzy patch of the Andromeda Galaxy (M31). Dark skies are needed for naked-eye viewing; binoculars show it clearly.',
          'Almach (Gamma And) is a beautiful gold and blue double star in small telescopes.',
          'Best viewed high in the sky during autumn evenings.'
        ]),

    // ---------- NEWLY ADDED CONSTELLATIONS START HERE ----------

    'Aquarius': ConstellationInfo(
      name: 'Aquarius',
      mythology:
          'The Water Bearer. Often identified with Ganymede, the beautiful Trojan youth abducted by Zeus (in the form of an eagle, Aquila) to be the cupbearer to the gods. Also associated with Deucalion, the survivor of the Great Flood.',
      bestViewing: 'Autumn months (Northern Hemisphere), Spring (Southern Hemisphere)',
      brightestStar: 'Sadalsuud (Beta Aquarii)',
      magnitude: '2.90',
      distance: '540 light-years',
      funFacts: [
        'One of the zodiac constellations.',
        'Contains the Helix Nebula (NGC 7293), one of the closest planetary nebulae.',
        'Home to the Saturn Nebula (NGC 7009).',
        'Features the "Water Jar" asterism.',
        'Radiant point for several meteor showers (Eta Aquariids, Delta Aquariids).'
      ],
      visibleFrom: 'Latitudes between +65° and -90°. Best seen in autumn (N. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek', interpretation: 'Ganymede, the cupbearer, or Deucalion.'),
        CulturalSignificance(culture: 'Roman', interpretation: 'Known as Aquarius (Water Carrier).'),
        CulturalSignificance(
            culture: 'Babylonian',
            interpretation: 'Associated with the god Ea, often depicted holding an overflowing vase.'),
        CulturalSignificance(culture: 'Egyptian', interpretation: 'Associated with Hapi, the god of the Nile flood.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Sadalsuud',
            designation: 'β Aqr',
            magnitude: '2.90',
            distance: '540 light-years',
            spectralType: 'G0Ib'),
        StarInfo(
            name: 'Sadalmelik',
            designation: 'α Aqr',
            magnitude: '2.94',
            distance: '520 light-years',
            spectralType: 'G2Ib'),
        StarInfo(
            name: 'Skat (Scheat)',
            designation: 'δ Aqr',
            magnitude: '3.27',
            distance: '160 light-years',
            spectralType: 'A3V'),
      ],
      historicalBackground:
          'An ancient constellation of the zodiac, recognized by Babylonians and Greeks. Listed by Ptolemy.',
      observationTips: [
        'Located between Capricornus and Pisces.',
        'Look for the small Y-shaped "Water Jar" asterism near the center.',
        'The Helix Nebula and Saturn Nebula require a telescope.',
        'Generally a fainter constellation, best observed under dark skies.'
      ],
    ),

    'Aquila': ConstellationInfo(
      name: 'Aquila',
      mythology:
          'The Eagle. Often represents the eagle that carried Zeus\'s thunderbolts or the eagle that abducted Ganymede (Aquarius).',
      bestViewing: 'Summer months (Northern Hemisphere)',
      brightestStar: 'Altair (Alpha Aquilae)',
      magnitude: '0.76',
      distance: '16.7 light-years',
      funFacts: [
        'Altair is one of the closest naked-eye stars to Earth.',
        'Altair forms the southern vertex of the Summer Triangle (with Vega and Deneb).',
        'Altair rotates very rapidly, causing it to be flattened at the poles.',
        'Lies along the Milky Way.'
      ],
      visibleFrom: 'Latitudes between +90° and -75°. Prominent in summer (N. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek', interpretation: 'The eagle of Zeus.'),
        CulturalSignificance(
            culture: 'Roman', interpretation: 'Known as Aquila (Eagle) or Vultur volans ("Flying Vulture").'),
        CulturalSignificance(
            culture: 'Chinese',
            interpretation:
                'Altair is Niulang (牛郎, the Cowherd) in the tale of the Cowherd and Weaver Girl (Vega/Zhi Nü).'),
        CulturalSignificance(culture: 'Hindu', interpretation: 'Associated with Garuda, the eagle mount of Vishnu.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Altair', designation: 'α Aql', magnitude: '0.76', distance: '16.7 light-years', spectralType: 'A7V'),
        StarInfo(
            name: 'Tarazed',
            designation: 'γ Aql',
            magnitude: '2.72',
            distance: '395 light-years',
            spectralType: 'K3II'),
        StarInfo(
            name: 'Okab', designation: 'ζ Aql', magnitude: '2.99', distance: '83 light-years', spectralType: 'A0Vn'),
      ],
      historicalBackground: 'One of Ptolemy\'s 48 constellations.',
      observationTips: [
        'Look for the bright star Altair, flanked by Tarazed and Alshain (Beta Aql), high in the summer sky.',
        'Altair forms the Summer Triangle with Vega (Lyra) and Deneb (Cygnus).',
        'The main body of the eagle extends south and east from Altair.',
        'Scan the Milky Way running through Aquila with binoculars.'
      ],
    ),

    'Aries': ConstellationInfo(
      name: 'Aries',
      mythology:
          'The Ram. Represents the ram with the Golden Fleece sought by Jason and the Argonauts. The fleece came from the ram that rescued Phrixus and Helle.',
      bestViewing: 'Autumn/Winter months (Northern Hemisphere)',
      brightestStar: 'Hamal (Alpha Arietis)',
      magnitude: '2.00',
      distance: '66 light-years',
      funFacts: [
        'One of the zodiac constellations.',
        'Historically, it contained the vernal equinox point (First Point of Aries), though this has shifted to Pisces due to precession.',
        'A relatively small and faint constellation.',
      ],
      visibleFrom: 'Latitudes between +90° and -60°. Best seen in late autumn/winter (N. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek', interpretation: 'The Ram with the Golden Fleece.'),
        CulturalSignificance(culture: 'Roman', interpretation: 'Known as Aries (Ram).'),
        CulturalSignificance(
            culture: 'Babylonian', interpretation: 'Known as MUL.LÚ.ḪUN.GÁ ("The Agrarian Worker" or "Hired Man").'),
        CulturalSignificance(
            culture: 'Egyptian',
            interpretation: 'Associated with the god Amon-Ra, sometimes depicted with a ram\'s head.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Hamal',
            designation: 'α Ari',
            magnitude: '2.00',
            distance: '66 light-years',
            spectralType: 'K2III Ca-1'),
        StarInfo(
            name: 'Sheratan', designation: 'β Ari', magnitude: '2.66', distance: '60 light-years', spectralType: 'A5V'),
        StarInfo(
            name: 'Mesarthim',
            designation: 'γ Ari',
            magnitude: '3.86 (combined)',
            distance: '164 light-years',
            spectralType: 'B9V + A1p Si...'), // Binary
      ],
      historicalBackground:
          'An ancient constellation of the zodiac, listed by Ptolemy. Held significance as the location of the vernal equinox in antiquity.',
      observationTips: [
        'Located between Pisces and Taurus.',
        'Look for a crooked line of three moderately bright stars: Hamal, Sheratan, and Mesarthim.',
        'Find it below Andromeda and Triangulum in the autumn/winter sky.',
        'Mesarthim is an easy double star for small telescopes.'
      ],
    ),

    'Auriga': ConstellationInfo(
      name: 'Auriga',
      mythology:
          'The Charioteer. Often identified with Erichthonius, mythical king of Athens who invented the four-horse chariot. Also sometimes linked to Myrtilus or even Amalthea, the goat who nursed Zeus (represented by the star Capella and nearby stars "the Kids").',
      bestViewing: 'Winter months (Northern Hemisphere)',
      brightestStar: 'Capella (Alpha Aurigae)',
      magnitude: '0.08 (combined)',
      distance: '42.9 light-years',
      funFacts: [
        'Capella is the sixth-brightest star in the night sky and is actually a system of four stars (two binary pairs).',
        'Features a prominent pentagon shape.',
        'Contains three bright Messier open clusters: M36, M37, and M38 (the "Auriga clusters").',
        'Lies along the Milky Way.',
      ],
      visibleFrom: 'Latitudes between +90° and -40°. Prominent in winter (N. Hemi).',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'Greek',
            interpretation: 'Erichthonius, the charioteer; sometimes associated with Amalthea the goat.'),
        CulturalSignificance(culture: 'Roman', interpretation: 'Known as Auriga (Charioteer).'),
        CulturalSignificance(culture: 'Babylonian', interpretation: 'Possibly associated with a chariot (MUL.GIGIR).'),
        CulturalSignificance(
            culture: 'Chinese', interpretation: 'Capella and other stars formed Wǔchē (五車), the Five Chariots.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Capella',
            designation: 'α Aur',
            magnitude: '0.08 (combined)',
            distance: '42.9 light-years',
            spectralType: 'G1III + G8III'), // Main binary pair
        StarInfo(
            name: 'Menkalinan',
            designation: 'β Aur',
            magnitude: '1.90 (variable)',
            distance: '81 light-years',
            spectralType: 'A1mIV + A1mIV'), // Eclipsing binary
        StarInfo(
            name: 'Mahasim',
            designation: 'θ Aur',
            magnitude: '2.65 (variable)',
            distance: '169 light-years',
            spectralType: 'A0p Si + F2-5V'), // Binary
        StarInfo(
            name: 'Hassaleh',
            designation: 'ι Aur',
            magnitude: '2.69',
            distance: '490 light-years',
            spectralType: 'K3II'),
        StarInfo(
            name: 'Almaaz (Haldus)',
            designation: 'ε Aur',
            magnitude: '2.98 (variable, long period eclipse)',
            distance: '~2000 light-years',
            spectralType: 'F0Ia + B V?'), // Very unusual eclipsing binary
      ],
      historicalBackground: 'One of Ptolemy\'s 48 constellations.',
      observationTips: [
        'Look for the bright yellow star Capella and the distinct pentagon shape high overhead in winter.',
        'Auriga is located near Taurus and Gemini.',
        'Scan the area within the pentagon with binoculars or a telescope for the open clusters M36, M37, and M38.',
        'Epsilon Aurigae ("Almaaz") is a fascinating eclipsing binary with a ~27 year period; its eclipses are studied by amateurs.'
      ],
    ),

    'Boötes': ConstellationInfo(
      name: 'Boötes',
      mythology:
          'The Herdsman or Ploughman. Often depicted driving the bears (Ursa Major and Ursa Minor) around the pole. Sometimes identified with Arcas (son of Callisto/Ursa Major) or Icarius, who learned winemaking from Dionysus.',
      bestViewing: 'Spring/Summer months (Northern Hemisphere)',
      brightestStar: 'Arcturus (Alpha Boötis)',
      magnitude: '-0.05',
      distance: '36.7 light-years',
      funFacts: [
        'Contains Arcturus, the fourth-brightest star in the night sky and the brightest in the Northern Hemisphere.',
        'Arcturus is an orange giant star.',
        'The constellation has a kite-like shape.',
        'Home to the Boötes Void, a huge region of space with very few galaxies.',
      ],
      visibleFrom: 'Latitudes between +90° and -50°. Prominent in spring/summer (N. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek', interpretation: 'The Herdsman driving the Bears, or Arcas, or Icarius.'),
        CulturalSignificance(culture: 'Roman', interpretation: 'Known as Boötes (Ox-driver).'),
        CulturalSignificance(
            culture: 'Arabic', interpretation: 'Arcturus means "Guardian of the Bear" (Haris al-Sama).'),
        CulturalSignificance(culture: 'Chinese', interpretation: 'Arcturus was Dàjiǎo (大角), the Great Horn.'),
        CulturalSignificance(
            culture: 'Polynesian',
            interpretation: 'Arcturus (Hōkūleʻa) was a critical zenith star for navigation to Hawaii.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Arcturus',
            designation: 'α Boo',
            magnitude: '-0.05',
            distance: '36.7 light-years',
            spectralType: 'K1.5III Fe-0.5'),
        StarInfo(
            name: 'Nekkar',
            designation: 'β Boo',
            magnitude: '3.49',
            distance: '225 light-years',
            spectralType: 'G8IIIa'),
        StarInfo(
            name: 'Seginus',
            designation: 'γ Boo',
            magnitude: '3.03 (variable)',
            distance: '85 light-years',
            spectralType: 'A7III delta Sct'),
        StarInfo(
            name: 'Izar',
            designation: 'ε Boo',
            magnitude: '2.37 (combined)',
            distance: '203 light-years',
            spectralType: 'K0II-III + A2V'), // Beautiful double star
      ],
      historicalBackground: 'An ancient constellation mentioned by Homer and listed by Ptolemy.',
      observationTips: [
        'Find Arcturus by following the arc of the Big Dipper\'s handle: "Arc to Arcturus".',
        'The rest of the constellation forms a kite shape extending north from Arcturus.',
        'Izar (Epsilon Boötis) is a stunning orange and blue-green double star in telescopes, nicknamed "Pulcherrima" (most beautiful).',
        'Best viewed high in the sky during late spring and summer evenings.'
      ],
    ),

    'Cancer': ConstellationInfo(
      name: 'Cancer',
      mythology:
          'The Crab. Sent by Hera to distract Heracles during his fight with the Hydra. Heracles crushed it, but Hera placed it among the stars. It is the faintest of the zodiac constellations.',
      bestViewing: 'Spring months (Northern Hemisphere)',
      brightestStar: 'Tarf (Beta Cancri)',
      magnitude: '3.52',
      distance: '290 light-years',
      funFacts: [
        'One of the zodiac constellations.',
        'Contains the Beehive Cluster (M44, Praesepe), a large, bright open cluster visible to the naked eye under dark skies.',
        'Contains the open cluster M67, one of the oldest known open clusters.',
        'The Tropic of Cancer is named after this constellation (though the Sun is now in Gemini during the summer solstice due to precession).',
      ],
      visibleFrom: 'Latitudes between +90° and -60°. Best seen in spring (N. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek', interpretation: 'The Crab crushed by Heracles.'),
        CulturalSignificance(culture: 'Roman', interpretation: 'Known as Cancer (Crab).'),
        CulturalSignificance(culture: 'Babylonian', interpretation: 'Known as MUL.AL.LUL ("The Crayfish").'),
        CulturalSignificance(culture: 'Egyptian', interpretation: 'Associated with a scarab beetle.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Tarf', designation: 'β Cnc', magnitude: '3.52', distance: '290 light-years', spectralType: 'K4III'),
        StarInfo(
            name: 'Asellus Australis',
            designation: 'δ Cnc',
            magnitude: '3.94',
            distance: '131 light-years',
            spectralType: 'K0III'),
        StarInfo(
            name: 'Acubens',
            designation: 'α Cnc',
            magnitude: '4.25 (variable)',
            distance: '174 light-years',
            spectralType: 'A5m'),
        StarInfo(
            name: 'Asellus Borealis',
            designation: 'γ Cnc',
            magnitude: '4.67',
            distance: '181 light-years',
            spectralType: 'A1IV'),
      ],
      historicalBackground: 'An ancient constellation of the zodiac, listed by Ptolemy, despite its faintness.',
      observationTips: [
        'Located between Gemini and Leo.',
        'Look for an inverted Y shape of faint stars.',
        'The main attraction is the Beehive Cluster (M44). Find it roughly midway between Pollux (Gemini) and Regulus (Leo). It appears as a fuzzy patch to the naked eye, resolving into stars in binoculars.',
        'Requires dark skies to appreciate the constellation itself.'
      ],
    ),

    'Canis Minor': ConstellationInfo(
      name: 'Canis Minor',
      mythology:
          'The Lesser Dog. Usually considered the second hunting dog of Orion, accompanying Canis Major. Also sometimes identified with Maera, the dog of Icarius (Boötes).',
      bestViewing: 'Winter months (Northern Hemisphere)',
      brightestStar: 'Procyon (Alpha Canis Minoris)',
      magnitude: '0.34',
      distance: '11.46 light-years',
      funFacts: [
        'Contains Procyon, the eighth-brightest star in the night sky.',
        'Procyon means "before the dog," as it rises shortly before Sirius (the "Dog Star") in the Northern Hemisphere.',
        'Procyon is a binary star, with a white dwarf companion (Procyon B).',
        'One of the smallest constellations, dominated by Procyon.',
        'Forms part of the Winter Hexagon/Circle asterism.'
      ],
      visibleFrom: 'Latitudes between +90° and -75°. Prominent in winter (N. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek', interpretation: 'Orion\'s lesser dog, or Maera.'),
        CulturalSignificance(culture: 'Roman', interpretation: 'Known as Canis Minor (Lesser Dog).'),
        CulturalSignificance(
            culture: 'Babylonian',
            interpretation: 'Possibly associated with twin representations along with parts of Gemini.'),
        CulturalSignificance(culture: 'Egyptian', interpretation: 'Procyon was recognized but its association varied.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Procyon',
            designation: 'α CMi',
            magnitude: '0.34',
            distance: '11.46 light-years',
            spectralType: 'F5IV-V + DQZ'), // Main star + white dwarf
        StarInfo(
            name: 'Gomeisa',
            designation: 'β CMi',
            magnitude: '2.89 (variable)',
            distance: '160 light-years',
            spectralType: 'B8Ve'),
      ],
      historicalBackground: 'One of Ptolemy\'s 48 constellations, though essentially just marking the star Procyon.',
      observationTips: [
        'Very easy to find: look for the bright star Procyon to the east of Orion and north of Sirius.',
        'The constellation basically consists of Procyon and the fainter Gomeisa nearby, forming a short line.',
        'Procyon forms an equilateral triangle with Betelgeuse (Orion) and Sirius (Canis Major), known as the Winter Triangle.'
      ],
    ),

    'Capricornus': ConstellationInfo(
      name: 'Capricornus',
      mythology:
          'The Sea-Goat. An ancient hybrid creature. Associated with the god Pan, who transformed his lower half into a fish tail to escape the monster Typhon by diving into the Nile. Also linked to Amalthea, the goat nymph who nursed Zeus.',
      bestViewing: 'Late Summer/Autumn (Northern Hemisphere), Late Winter/Spring (Southern Hemisphere)',
      brightestStar: 'Deneb Algedi (Delta Capricorni)',
      magnitude: '2.81 (variable)',
      distance: '38.7 light-years',
      funFacts: [
        'One of the zodiac constellations.',
        'One of the faintest zodiac constellations.',
        'The Tropic of Capricorn is named after it (though the Sun is now in Sagittarius during the winter solstice due to precession).',
        'The planet Neptune was discovered near Deneb Algedi in 1846.',
      ],
      visibleFrom: 'Latitudes between +60° and -90°. Best seen in late summer/autumn (N. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek', interpretation: 'The Sea-Goat (Pan or Amalthea).'),
        CulturalSignificance(culture: 'Roman', interpretation: 'Known as Capricornus (Horned Goat).'),
        CulturalSignificance(
            culture: 'Babylonian',
            interpretation: 'Known as MUL.SUḪUR.MAŠ ("The Goat-Fish"). Associated with the god Ea.'),
        CulturalSignificance(culture: 'Sumerian', interpretation: 'Associated with Enki (equivalent of Ea).'),
      ],
      mainStars: [
        StarInfo(
            name: 'Deneb Algedi',
            designation: 'δ Cap',
            magnitude: '2.81 (variable)',
            distance: '38.7 light-years',
            spectralType: 'A7m III'), // Eclipsing binary
        StarInfo(
            name: 'Dabih',
            designation: 'β Cap',
            magnitude: '3.08 (combined)',
            distance: '328 light-years',
            spectralType: 'F8:V + B9.5III'), // Complex multiple system
        StarInfo(
            name: 'Algedi (Giedi)',
            designation: 'α Cap',
            magnitude: '3.57 + 4.27 (visual double)',
            distance: '687 + 106 light-years',
            spectralType: 'G3Ib + G8.5III'), // Optical double (α¹ & α²)
        StarInfo(
            name: 'Nashira',
            designation: 'γ Cap',
            magnitude: '3.67',
            distance: '139 light-years',
            spectralType: 'A7III mp'),
      ],
      historicalBackground: 'An ancient constellation of the zodiac, known since Sumerian times. Listed by Ptolemy.',
      observationTips: [
        'Located between Aquarius and Sagittarius.',
        'Look for a large triangle shape of faint stars.',
        'Algedi (Alpha Cap) is a naked-eye double star (optical, not physically related).',
        'Dabih (Beta Cap) is a nice double star in binoculars or small telescopes.',
        'Best observed under dark skies due to its faintness.'
      ],
    ),

    'Carina': ConstellationInfo(
      name: 'Carina',
      mythology:
          'The Keel (of the former constellation Argo Navis, the ship of Jason and the Argonauts). Argo Navis was divided into Carina, Puppis (Stern), and Vela (Sails) by Lacaille in the 18th century.',
      bestViewing: 'Winter/Spring (Southern Hemisphere)',
      brightestStar: 'Canopus (Alpha Carinae)',
      magnitude: '-0.74',
      distance: '310 light-years',
      funFacts: [
        'Contains Canopus, the second-brightest star in the night sky.',
        'Home to the spectacular Carina Nebula (NGC 3372), larger and brighter than the Orion Nebula, containing the star Eta Carinae.',
        'Eta Carinae is a massive, unstable luminous blue variable star system, expected to explode as a supernova/hypernova.',
        'Contains the "Diamond Cross" and "False Cross" asterisms (often confused with Crux).',
      ],
      visibleFrom: 'Latitudes south of +20° (best below -30°). Prominent in summer (S. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek/Roman (as Argo Navis)', interpretation: 'The ship of the Argonauts.'),
        CulturalSignificance(culture: 'Modern (Post-Lacaille)', interpretation: 'The Keel of the ship.'),
        CulturalSignificance(culture: 'Polynesian', interpretation: 'Canopus was an important navigational star.'),
        CulturalSignificance(
            culture: 'African (various)', interpretation: 'Canopus often had significant cultural meaning.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Canopus',
            designation: 'α Car',
            magnitude: '-0.74',
            distance: '310 light-years',
            spectralType: 'A9II'),
        StarInfo(
            name: 'Miaplacidus',
            designation: 'β Car',
            magnitude: '1.69',
            distance: '113 light-years',
            spectralType: 'A1III'),
        StarInfo(
            name: 'Avior',
            designation: 'ε Car',
            magnitude: '1.86 (combined)',
            distance: '605 light-years',
            spectralType: 'K3III + B2Vp'), // Binary
        StarInfo(
            name: 'Aspidiske',
            designation: 'ι Car',
            magnitude: '2.21',
            distance: '765 light-years',
            spectralType: 'A8Ib'),
        StarInfo(
            name: 'Eta Carinae',
            designation: 'η Car',
            magnitude: 'Variable (~4-5, was brighter)',
            distance: '~7500 light-years',
            spectralType: 'LBV'), // Luminous Blue Variable system
      ],
      historicalBackground:
          'Originally part of the large Ptolemaic constellation Argo Navis. Formally defined as Carina by Nicolas-Louis de Lacaille in the 1750s.',
      observationTips: [
        'Locate the extremely bright star Canopus.',
        'The Carina Nebula (NGC 3372) is a stunning naked-eye object in dark southern skies, surrounding Eta Carinae. Spectacular in binoculars/telescopes.',
        'Identify the Diamond Cross asterism (Miaplacidus, Theta Car, Upsilon Car, Omega Car).',
        'Be aware of the False Cross (Aspidiske, Avior, Delta Vel, Kappa Vel), often mistaken for the Southern Cross (Crux).',
        'The open cluster IC 2602 ("Southern Pleiades") is another highlight.'
      ],
    ),

    'Centaurus': ConstellationInfo(
      name: 'Centaurus',
      mythology:
          'The Centaur. Usually identified with Chiron, the wise and immortal centaur who tutored many Greek heroes (though Sagittarius is sometimes also identified as Chiron). Alternatively, represents Pholus.',
      bestViewing: 'Autumn/Winter (Southern Hemisphere)',
      brightestStar: 'Alpha Centauri (Rigil Kentaurus)',
      magnitude: '-0.27 (combined)',
      distance: '4.37 light-years',
      funFacts: [
        'Contains Alpha Centauri, the closest star system to the Sun.',
        'Alpha Centauri itself is a triple system (Alpha Cen A, Alpha Cen B, and Proxima Centauri). Proxima is the closest individual star.',
        'Home to Omega Centauri (NGC 5139), the largest and brightest globular cluster in the Milky Way, visible to the naked eye.',
        'Contains Centaurus A (NGC 5128), a peculiar galaxy and strong radio source.',
        'Beta Centauri (Hadar) is the 11th brightest star in the sky.',
      ],
      visibleFrom: 'Latitudes between +25° and -90°. Prominent in winter (S. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek', interpretation: 'Chiron or Pholus, the centaur.'),
        CulturalSignificance(culture: 'Roman', interpretation: 'Known as Centaurus.'),
        CulturalSignificance(
            culture: 'Aboriginal Australian',
            interpretation: 'Alpha and Beta Centauri often formed figures like two brothers or pointer stars.'),
        CulturalSignificance(
            culture: 'African (various)', interpretation: 'Alpha and Beta Centauri were often known as "pointers".'),
      ],
      mainStars: [
        StarInfo(
            name: 'Alpha Centauri (Rigil Kentaurus)',
            designation: 'α Cen',
            magnitude: '-0.27 (combined)',
            distance: '4.37 light-years',
            spectralType: 'G2V + K1V (+ M5.5Ve Proxima)'),
        StarInfo(
            name: 'Hadar (Agena)',
            designation: 'β Cen',
            magnitude: '0.61 (variable)',
            distance: '390 light-years',
            spectralType: 'B1III'), // Triple system
        StarInfo(
            name: 'Menkent',
            designation: 'θ Cen',
            magnitude: '2.06',
            distance: '59 light-years',
            spectralType: 'K0IIIb'),
        StarInfo(
            name: 'Muhlifain',
            designation: 'γ Cen',
            magnitude: '2.17 (combined)',
            distance: '130 light-years',
            spectralType: 'A1IV + A1IV'), // Binary
      ],
      historicalBackground: 'One of Ptolemy\'s 48 constellations.',
      observationTips: [
        'Find the two very bright stars Alpha Centauri and Hadar (Beta Cen). They are known as "The Pointers" because they point towards Crux (Southern Cross).',
        'Omega Centauri (NGC 5139) appears as a large, hazy star to the naked eye under dark skies. It is spectacular in binoculars or a telescope.',
        'Centaurus A (NGC 5128) is a challenging but rewarding target for telescopes.',
        'A large constellation stretching across a rich part of the southern Milky Way.'
      ],
    ),

    'Crux': ConstellationInfo(
      name: 'Crux',
      mythology:
          'The Southern Cross. While known to the ancient Greeks (as part of Centaurus), it became significant to European navigators in the Age of Discovery as a symbol and navigational aid. It has deep significance in many Southern Hemisphere cultures.',
      bestViewing: 'Autumn/Winter (Southern Hemisphere), Circumpolar from latitudes south of 34°S.',
      brightestStar: 'Acrux (Alpha Crucis)',
      magnitude: '0.76 (combined)',
      distance: '321 light-years',
      funFacts: [
        'The smallest of the 88 modern constellations by area.',
        'Its distinctive cross shape is a prominent feature of the southern sky.',
        'Used for finding the South Celestial Pole.',
        'Contains the Coalsack Nebula, a famous dark nebula easily visible next to the cross.',
        'Home to the Jewel Box Cluster (NGC 4755), a bright open cluster near Mimosa.',
      ],
      visibleFrom: 'Latitudes south of +20° (best seen south of the equator).',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'European (Post-exploration)',
            interpretation: 'Symbol of the Christian cross, navigational marker.'),
        CulturalSignificance(
            culture: 'Aboriginal Australian (various)',
            interpretation: 'Represents figures like a possum in a tree (Boorong) or the eagle Mirrabooka.'),
        CulturalSignificance(culture: 'Maori (New Zealand)', interpretation: 'Called "Te Punga" (The Anchor).'),
        CulturalSignificance(
            culture: 'Inca',
            interpretation: 'Associated with the "Chakana" (Inca Cross), a symbol of the southern sky.'),
        CulturalSignificance(culture: 'Brazil', interpretation: 'Featured on the national flag and coat of arms.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Acrux',
            designation: 'α Cru',
            magnitude: '0.76 (combined)',
            distance: '321 light-years',
            spectralType: 'B0.5IV + B1V'), // Multiple system
        StarInfo(
            name: 'Mimosa (Becrux)',
            designation: 'β Cru',
            magnitude: '1.25 (variable)',
            distance: '280 light-years',
            spectralType: 'B0.5III'), // Beta Cephei variable
        StarInfo(
            name: 'Gacrux',
            designation: 'γ Cru',
            magnitude: '1.59 (combined)',
            distance: '88.6 light-years',
            spectralType: 'M3.5III + A3V'), // Optical double or wide binary
        StarInfo(
            name: 'Imai (Delta Crucis)',
            designation: 'δ Cru',
            magnitude: '2.79 (variable)',
            distance: '345 light-years',
            spectralType: 'B2IV'), // Beta Cephei variable
      ],
      historicalBackground:
          'Stars known since antiquity but considered part of Centaurus by Ptolemy. Defined as a separate constellation by Augustin Royer in 1679, popularized by navigators.',
      observationTips: [
        'Easily recognizable bright cross shape in the southern sky.',
        'Use the Pointers (Alpha and Beta Centauri) to confirm its location.',
        'Extend the long axis of the cross about 4.5 times to find the South Celestial Pole (no bright pole star).',
        'Look for the dark patch of the Coalsack Nebula adjacent to the cross.',
        'The Jewel Box Cluster (NGC 4755) is a stunning sight near Mimosa (Beta Cru) in binoculars or a telescope.'
      ],
    ),

    'Draco': ConstellationInfo(
      name: 'Draco',
      mythology:
          'The Dragon. Often identified with Ladon, the dragon who guarded the golden apples in the Garden of the Hesperides and was slain by Heracles. Also associated with the dragon defeated by Cadmus or one of the Titans defeated by Athena.',
      bestViewing: 'Spring/Summer (Northern Hemisphere), Circumpolar for many northern latitudes.',
      brightestStar: 'Eltanin (Gamma Draconis)', // Despite being Gamma, it's the brightest
      magnitude: '2.24',
      distance: '154 light-years',
      funFacts: [
        'Winds its way between Ursa Major and Ursa Minor.',
        'The star Thuban (Alpha Draconis) was the North Pole star around 3000 BC (time of the Egyptian pyramids).',
        'Contains the Cat\'s Eye Nebula (NGC 6543), a bright planetary nebula.',
        'The head of the dragon is formed by four stars near Vega (Lyra).',
      ],
      visibleFrom: 'Latitudes north of -15° (circumpolar for mid-northern latitudes).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek', interpretation: 'Ladon, the dragon guarding the Hesperides.'),
        CulturalSignificance(culture: 'Roman', interpretation: 'Known as Draco (Dragon).'),
        CulturalSignificance(
            culture: 'Arabic',
            interpretation: 'The stars forming the head were seen as "Mother Camels". Thuban means "serpent".'),
        CulturalSignificance(culture: 'Hindu', interpretation: 'Associated with a celestial crocodile or alligator.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Eltanin (Etamin)',
            designation: 'γ Dra',
            magnitude: '2.24',
            distance: '154 light-years',
            spectralType: 'K5III'),
        StarInfo(
            name: 'Rastaban',
            designation: 'β Dra',
            magnitude: '2.79',
            distance: '380 light-years',
            spectralType: 'G2II'),
        StarInfo(
            name: 'Altais', designation: 'δ Dra', magnitude: '3.07', distance: '97 light-years', spectralType: 'G9III'),
        StarInfo(
            name: 'Thuban',
            designation: 'α Dra',
            magnitude: '3.65',
            distance: '303 light-years',
            spectralType: 'A0III'), // Former pole star
        StarInfo(
            name: 'Grumium',
            designation: 'ξ Dra',
            magnitude: '3.75',
            distance: '112 light-years',
            spectralType: 'K2III'),
      ],
      historicalBackground: 'One of Ptolemy\'s 48 constellations.',
      observationTips: [
        'Trace the long, winding body starting between the Big Dipper and Little Dipper.',
        'The tail end is near the pointers of the Big Dipper.',
        'The head is a quadrilateral of stars (Rastaban, Eltanin, Grumium, Nu Draconis) located near Vega.',
        'Thuban (Alpha Dra) can be found about halfway between Mizar (Ursa Major) and Kochab (Ursa Minor).',
        'The Cat\'s Eye Nebula requires a telescope.'
      ],
    ),

    'Hercules': ConstellationInfo(
      name: 'Hercules',
      mythology:
          'Represents the Roman equivalent of the Greek hero Heracles, renowned for his strength and completion of the Twelve Labors.',
      bestViewing: 'Summer (Northern Hemisphere)',
      brightestStar: 'Kornephoros (Beta Herculis)', // Despite being Beta, it's the brightest
      magnitude: '2.81 (variable)',
      distance: '139 light-years',
      funFacts: [
        'The fifth largest modern constellation.',
        'Contains the Keystone asterism, a quadrilateral marking the torso of Hercules.',
        'Home to the Great Globular Cluster in Hercules (M13), one of the brightest globular clusters in the northern sky.',
        'Also contains the globular cluster M92.',
        'The solar apex (the direction the Sun is moving relative to nearby stars) lies within Hercules.',
      ],
      visibleFrom: 'Latitudes between +90° and -50°. Prominent in summer (N. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek/Roman', interpretation: 'Heracles/Hercules, the hero.'),
        CulturalSignificance(
            culture: 'Sumerian/Babylonian', interpretation: 'Possibly associated with Gilgamesh or other figures.'),
        CulturalSignificance(culture: 'Chinese', interpretation: 'Stars incorporated into various asterisms.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Kornephoros',
            designation: 'β Her',
            magnitude: '2.81 (variable)',
            distance: '139 light-years',
            spectralType: 'G7IIIa'),
        StarInfo(
            name: 'Rasalgethi',
            designation: 'α Her',
            magnitude: '3.35 (variable, combined)',
            distance: '359 light-years',
            spectralType: 'M5Ib-II + G5III'), // Beautiful double star
        StarInfo(
            name: 'Sarin',
            designation: 'δ Her',
            magnitude: '3.12',
            distance: '75 light-years',
            spectralType: 'A3IV + G4'), // Binary
        StarInfo(
            name: 'Marfik',
            designation: 'κ Her',
            magnitude: '4.61 (combined)',
            distance: '388 light-years',
            spectralType: 'G8III + K1III'), // Binary
        StarInfo(
            name: 'Ruticulus',
            designation: 'ζ Her',
            magnitude: '2.81 (combined)',
            distance: '35 light-years',
            spectralType: 'F9IV + G7V'), // Binary
      ],
      historicalBackground: 'One of Ptolemy\'s 48 constellations, originally depicted kneeling ("Engonasin").',
      observationTips: [
        'Located between Lyra and Boötes.',
        'Find the Keystone asterism (formed by Pi, Epsilon, Zeta, and Eta Herculis).',
        'The Great Globular Cluster (M13) is located on the western side of the Keystone, between Eta and Zeta. Visible as a fuzzy patch in binoculars, spectacular in telescopes.',
        'M92 is another globular cluster nearby, also visible in binoculars/telescopes.',
        'Rasalgethi (Alpha Her) is a beautiful red and greenish-blue double star in telescopes.'
      ],
    ),

    'Libra': ConstellationInfo(
      name: 'Libra',
      mythology:
          'The Scales or Balance. Unique among zodiac constellations as the only inanimate object. Represents the scales of justice, often held by the adjacent constellation Virgo (representing Astraea/Dike, goddess of justice).',
      bestViewing: 'Late Spring/Summer (Northern Hemisphere)',
      brightestStar: 'Zubeneschamali (Beta Librae)',
      magnitude: '2.61',
      distance: '185 light-years',
      funFacts: [
        'One of the zodiac constellations.',
        'Historically, its stars formed the claws of Scorpius (its brightest stars still have names meaning "southern claw" and "northern claw").',
        'Zubeneschamali (Beta Lib) is reputed to be the only naked-eye star that appears greenish to some observers.',
        'Contains Methuselah Star (HD 140283), one of the oldest known stars.',
      ],
      visibleFrom: 'Latitudes between +65° and -90°. Best seen in late spring/summer (N. Hemi).',
      culturalSignificance: [
        CulturalSignificance(
            culture: 'Greek',
            interpretation: 'Originally the Claws of Scorpius, later the Scales of Justice (held by Virgo).'),
        CulturalSignificance(
            culture: 'Roman',
            interpretation: 'Established as Libra (Scales), associated with balanced seasons or justice.'),
        CulturalSignificance(culture: 'Babylonian', interpretation: 'Known as ZIB.BA.AN.NA ("The Balance").'),
      ],
      mainStars: [
        StarInfo(
            name: 'Zubeneschamali',
            designation: 'β Lib',
            magnitude: '2.61',
            distance: '185 light-years',
            spectralType: 'B8V'),
        StarInfo(
            name: 'Zubenelgenubi',
            designation: 'α Lib',
            magnitude: '2.74 (combined)',
            distance: '76 light-years',
            spectralType: 'A3V + F4V'), // Binary, easy split
        StarInfo(
            name: 'Brachium',
            designation: 'σ Lib',
            magnitude: '3.29 (variable)',
            distance: '288 light-years',
            spectralType: 'M3-4III'),
        StarInfo(
            name: 'Zubenelhakrabi',
            designation: 'γ Lib',
            magnitude: '3.91',
            distance: '161 light-years',
            spectralType: 'G8.5III'),
      ],
      historicalBackground:
          'Recognized as distinct from Scorpius by the Romans, though its stars were known much earlier as part of the scorpion figure. One of Ptolemy\'s 48 constellations (as Chelae - Claws, but described as holding scales).',
      observationTips: [
        'Located between Virgo and Scorpius.',
        'Look for a diamond or quadrilateral shape formed by its main stars.',
        'Zubenelgenubi (Alpha Lib) is an easy double star to split in binoculars or even with good eyesight.',
        'Zubeneschamali (Beta Lib) might appear slightly greenish.',
        'A relatively faint constellation.'
      ],
    ),

    'Pisces': ConstellationInfo(
      name: 'Pisces',
      mythology:
          'The Fishes. Represents Aphrodite and her son Eros, who transformed into fish and tied themselves together with a rope to escape the monster Typhon by jumping into the Euphrates river.',
      bestViewing: 'Autumn (Northern Hemisphere)',
      brightestStar: 'Eta Piscium (Alpherg)', // Despite being Eta, often considered brightest
      magnitude: '3.62',
      distance: '353 light-years',
      funFacts: [
        'One of the zodiac constellations.',
        'A large but faint constellation.',
        'Currently contains the vernal equinox point (the location of the Sun on the first day of spring in the Northern Hemisphere).',
        'Features the "Circlet" asterism, representing the head of the western fish.',
        'Contains M74, a face-on spiral galaxy (difficult target).',
      ],
      visibleFrom: 'Latitudes between +90° and -65°. Best seen in autumn (N. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek', interpretation: 'Aphrodite and Eros transformed into fish.'),
        CulturalSignificance(culture: 'Roman', interpretation: 'Known as Pisces (Fishes).'),
        CulturalSignificance(
            culture: 'Babylonian',
            interpretation: 'Known as MUL.SIM.MAḪ ("The Tail" or "The Swallow"). Associated with fish/goddesses.'),
        CulturalSignificance(
            culture: 'Syrian', interpretation: 'Associated with fertility goddesses represented as fish.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Eta Piscium (Alpherg)',
            designation: 'η Psc',
            magnitude: '3.62',
            distance: '353 light-years',
            spectralType: 'G7IIIa'),
        StarInfo(
            name: 'Gamma Piscium',
            designation: 'γ Psc',
            magnitude: '3.70',
            distance: '138 light-years',
            spectralType: 'G8III'),
        StarInfo(
            name: 'Alrescha',
            designation: 'α Psc',
            magnitude: '3.82 (combined)',
            distance: '151 light-years',
            spectralType: 'A0p Si + A3m'), // Binary, represents the knot
        StarInfo(
            name: 'Omega Piscium',
            designation: 'ω Psc',
            magnitude: '4.03',
            distance: '104 light-years',
            spectralType: 'F4IV'),
      ],
      historicalBackground: 'An ancient constellation of the zodiac, listed by Ptolemy.',
      observationTips: [
        'Located between Aquarius and Aries, south of Pegasus and Andromeda.',
        'Look for the "Circlet" asterism (a faint ring of stars) south of the Great Square of Pegasus.',
        'Trace the faint lines of stars representing ribbons leading east and north to the two fish.',
        'Alrescha (Alpha Psc), representing the knot tying the fish together, is a close double star requiring a telescope.',
        'Requires very dark skies to see well.'
      ],
    ),

    'Puppis': ConstellationInfo(
      name: 'Puppis',
      mythology:
          'The Stern or Poop Deck (of the former constellation Argo Navis, the ship of Jason and the Argonauts).',
      bestViewing: 'Winter/Spring (Southern Hemisphere), Winter (low in south for N. Hemi)',
      brightestStar: 'Naos (Zeta Puppis)',
      magnitude: '2.21',
      distance: '~1080 light-years',
      funFacts: [
        'The largest of the three constellations split from Argo Navis.',
        'Lies in a rich part of the Milky Way.',
        'Naos (Zeta Pup) is one of the hottest and most luminous naked-eye stars known (O-type star).',
        'Contains numerous open clusters, including M46, M47, M93, and NGC 2451.',
        'Home to the Puppis A supernova remnant.',
      ],
      visibleFrom: 'Latitudes between +40° and -90°. Best seen in winter/spring (S. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek/Roman (as Argo Navis)', interpretation: 'The ship of the Argonauts.'),
        CulturalSignificance(culture: 'Modern (Post-Lacaille)', interpretation: 'The Stern of the ship.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Naos',
            designation: 'ζ Pup',
            magnitude: '2.21',
            distance: '~1080 light-years',
            spectralType: 'O4If(n)p'),
        StarInfo(
            name: 'Pi Puppis',
            designation: 'π Pup',
            magnitude: '2.71',
            distance: '810 light-years',
            spectralType: 'K3Ib'),
        StarInfo(
            name: 'Tureis',
            designation: 'ρ Pup',
            magnitude: '2.78 (variable)',
            distance: '63.5 light-years',
            spectralType: 'F6IIp delta Sct'),
        StarInfo(
            name: 'Azmidi (Aspidiske)',
            designation: 'ξ Pup',
            magnitude: '3.35',
            distance: '~1200 light-years',
            spectralType: 'G6Ib'),
      ],
      historicalBackground:
          'Originally part of the large Ptolemaic constellation Argo Navis. Formally defined as Puppis by Nicolas-Louis de Lacaille in the 1750s.',
      observationTips: [
        'Located south/southeast of Canis Major.',
        'Look for the bright blue star Naos.',
        'Scan the area with binoculars or a telescope for its rich collection of open clusters.',
        'M46 and M47 are a nice pair in binoculars/wide-field telescopes.',
        'Lies across the Milky Way, making it a great area for wide-field observation.'
      ],
    ),

    'Sagittarius': ConstellationInfo(
      name: 'Sagittarius',
      mythology:
          'The Archer, usually depicted as a centaur pulling back a bow. Often identified with Crotus, the inventor of archery, or sometimes Chiron (conflicting with Centaurus). Aiming his arrow at the heart of Scorpius (Antares).',
      bestViewing: 'Summer (Northern Hemisphere), Winter (Southern Hemisphere)',
      brightestStar: 'Kaus Australis (Epsilon Sagittarii)',
      magnitude: '1.85',
      distance: '143 light-years',
      funFacts: [
        'One of the zodiac constellations.',
        'Contains the center of the Milky Way Galaxy.',
        'Features the prominent "Teapot" asterism.',
        'Extremely rich in nebulae (Lagoon M8, Trifid M20, Omega M17, Eagle M16) and star clusters (M22, M25, M28).',
        'The Galactic Center (Sagittarius A*) is located near the spout of the Teapot.',
      ],
      visibleFrom: 'Latitudes between +55° and -90°. Prominent in summer (N. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek', interpretation: 'The Archer centaur (Crotus or Chiron).'),
        CulturalSignificance(culture: 'Roman', interpretation: 'Known as Sagittarius (Archer).'),
        CulturalSignificance(
            culture: 'Babylonian', interpretation: 'Associated with the god Pabilsag, a centaur-like figure.'),
        CulturalSignificance(culture: 'Sumerian', interpretation: 'Associated with Nergal, god of war.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Kaus Australis',
            designation: 'ε Sgr',
            magnitude: '1.85',
            distance: '143 light-years',
            spectralType: 'B9.5III'),
        StarInfo(
            name: 'Nunki', designation: 'σ Sgr', magnitude: '2.05', distance: '228 light-years', spectralType: 'B2.5V'),
        StarInfo(
            name: 'Ascella',
            designation: 'ζ Sgr',
            magnitude: '2.59 (combined)',
            distance: '88 light-years',
            spectralType: 'A2.5V + A4V'), // Binary
        StarInfo(
            name: 'Kaus Media',
            designation: 'δ Sgr',
            magnitude: '2.70',
            distance: '348 light-years',
            spectralType: 'K3III'),
        StarInfo(
            name: 'Kaus Borealis',
            designation: 'λ Sgr',
            magnitude: '2.82',
            distance: '78 light-years',
            spectralType: 'K0IV'),
      ],
      historicalBackground: 'An ancient constellation of the zodiac, listed by Ptolemy.',
      observationTips: [
        'Look for the distinct "Teapot" asterism low in the southern sky during summer (N. Hemisphere) or high overhead (S. Hemisphere).',
        'The densest part of the Milky Way runs through Sagittarius, appearing as "steam" from the Teapot\'s spout.',
        'Use binoculars to scan the Milky Way here for numerous nebulae and clusters (M8, M20, M17, M22 are highlights).',
        'The center of the galaxy lies just west of the spout stars.'
      ],
    ),

    'Vela': ConstellationInfo(
      name: 'Vela',
      mythology: 'The Sails (of the former constellation Argo Navis, the ship of Jason and the Argonauts).',
      bestViewing: 'Winter/Spring (Southern Hemisphere)',
      brightestStar:
          'Regor (Gamma Velorum)', // Officially unnamed, Regor is informal/disputed. Gamma Vel is primary identifier.
      magnitude: '1.78 (combined)',
      distance: '~1100 light-years',
      funFacts: [
        'Part of the former Argo Navis.',
        'Gamma Velorum is a spectacular multiple star system containing the closest Wolf-Rayet star to Earth.',
        'Contains the Vela Supernova Remnant, including the Vela Pulsar.',
        'Shares the "False Cross" asterism with Carina.',
        'Home to the Eight-Burst Nebula (NGC 3132).',
      ],
      visibleFrom: 'Latitudes between +30° and -90°. Best seen in winter/spring (S. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek/Roman (as Argo Navis)', interpretation: 'The ship of the Argonauts.'),
        CulturalSignificance(culture: 'Modern (Post-Lacaille)', interpretation: 'The Sails of the ship.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Gamma Velorum (Regor)',
            designation: 'γ Vel',
            magnitude: '1.78 (combined)',
            distance: '~1100 light-years',
            spectralType: 'WC8 + O7.5III'), // Wolf-Rayet + O-type binary, multiple system
        StarInfo(
            name: 'Suhail (Al Suhail al Muhlif)',
            designation: 'λ Vel',
            magnitude: '2.21 (variable)',
            distance: '545 light-years',
            spectralType: 'K4Ib-II'),
        StarInfo(
            name: 'Delta Velorum',
            designation: 'δ Vel',
            magnitude: '1.96 (combined, variable)',
            distance: '80.6 light-years',
            spectralType: 'A1Va(n) + A5V'), // Eclipsing binary, part of False Cross
        StarInfo(
            name: 'Markeb',
            designation: 'κ Vel',
            magnitude: '2.48',
            distance: '572 light-years',
            spectralType: 'B2IV'), // Part of False Cross
      ],
      historicalBackground:
          'Originally part of the large Ptolemaic constellation Argo Navis. Formally defined as Vela by Nicolas-Louis de Lacaille in the 1750s.',
      observationTips: [
        'Located between Carina, Puppis, and Centaurus.',
        'Gamma Velorum is a bright star, notable for being the brightest Wolf-Rayet system.',
        'Identify the False Cross asterism (Delta Vel, Kappa Vel, Avior (Epsilon Car), Aspidiske (Iota Car)).',
        'The Vela Supernova Remnant is a large, faint structure requiring wide-field photographs or specialized filters.',
        'The Eight-Burst Nebula (NGC 3132) is a nice planetary nebula for telescopes.'
      ],
    ),

    'Virgo': ConstellationInfo(
      name: 'Virgo',
      mythology:
          'The Virgin or Maiden. Often identified with Demeter (goddess of the harvest), her daughter Persephone, or Astraea (goddess of justice, who fled Earth when humanity became wicked) holding the scales (Libra).',
      bestViewing: 'Spring (Northern Hemisphere)',
      brightestStar: 'Spica (Alpha Virginis)',
      magnitude: '1.00 (variable)',
      distance: '250 light-years',
      funFacts: [
        'The largest constellation of the zodiac and the second-largest overall.',
        'Contains Spica, a bright blue-white star.',
        'Home to the Virgo Cluster, a massive cluster of thousands of galaxies, including many Messier objects (M49, M58, M59, M60, M61, M84, M86, M87, M89, M90).',
        'M87 contains a supermassive black hole famously imaged by the Event Horizon Telescope.',
        'Contains the Sombrero Galaxy (M104).',
      ],
      visibleFrom: 'Latitudes between +80° and -80°. Prominent in spring (N. Hemi).',
      culturalSignificance: [
        CulturalSignificance(culture: 'Greek', interpretation: 'Demeter, Persephone, or Astraea (Justice).'),
        CulturalSignificance(culture: 'Roman', interpretation: 'Known as Virgo (Maiden).'),
        CulturalSignificance(
            culture: 'Babylonian', interpretation: 'Associated with "The Furrow" (MUL.AB.SIN) and the goddess Shala.'),
        CulturalSignificance(culture: 'Egyptian', interpretation: 'Associated with the goddess Isis.'),
      ],
      mainStars: [
        StarInfo(
            name: 'Spica',
            designation: 'α Vir',
            magnitude: '1.00 (variable)',
            distance: '250 light-years',
            spectralType: 'B1V + B2V'), // Eclipsing binary, spectroscopic binary
        StarInfo(
            name: 'Porrima (Antevorta)',
            designation: 'γ Vir',
            magnitude: '2.74 (combined)',
            distance: '38 light-years',
            spectralType: 'F0V + F0V'), // Close binary
        StarInfo(
            name: 'Vindemiatrix (Almuredin)',
            designation: 'ε Vir',
            magnitude: '2.83',
            distance: '110 light-years',
            spectralType: 'G8III'),
        StarInfo(
            name: 'Heze', designation: 'ζ Vir', magnitude: '3.37', distance: '74 light-years', spectralType: 'A3V'),
        StarInfo(
            name: 'Zavijava (Alaraph)',
            designation: 'β Vir',
            magnitude: '3.60',
            distance: '35.7 light-years',
            spectralType: 'F9V'),
      ],
      historicalBackground: 'An ancient constellation of the zodiac, listed by Ptolemy.',
      observationTips: [
        'Find the bright star Spica by following the arc of the Big Dipper\'s handle to Arcturus, then "spike" or "speed on" to Spica.',
        'The main constellation forms a large Y-shape.',
        'The Virgo Cluster of galaxies is located primarily between Vindemiatrix (Epsilon Vir) and Denebola (Beta Leo). A telescope is needed to see the individual galaxies, best viewed under dark skies.',
        'Porrima (Gamma Vir) is a famous binary star, currently very close but will widen over coming decades.',
        'The Sombrero Galaxy (M104) is near the border with Corvus.'
      ],
    ),

    // 'Eridanus': ConstellationInfo(
    //   name: 'Eridanus',
    //   mythology:
    //       'The River. Often identified with the river into which Phaethon fell after losing control of the Sun Chariot. Also linked to the Nile or Po rivers.',
    //   bestViewing: 'Winter (Northern Hemisphere), Summer (Southern Hemisphere)',
    //   brightestStar: 'Achernar (Alpha Eridani)',
    //   magnitude: '0.45 (variable)',
    //   distance: '139 light-years',
    //   funFacts: [
    //     'The sixth largest constellation by area.',
    //     'Stretches over a huge range of declination, from near Orion down to the south celestial pole region.',
    //     'Achernar is one of the flattest stars known due to its extremely rapid rotation.',
    //     'Contains the Eridanus Supervoid, one of the largest known voids in the universe.',
    //     'Home to Epsilon Eridani, a nearby star system with known exoplanets.',
    //   ],
    //   visibleFrom: 'Latitudes between +32° and -90°. Very long constellation.',
    //   culturalSignificance: [
    //     CulturalSignificance(culture: 'Greek', interpretation: 'The celestial river (Po, Nile, or mythical).'),
    //     CulturalSignificance(culture: 'Roman', interpretation: 'Known as Eridanus (River).'),
    //     CulturalSignificance(culture: 'Babylonian', interpretation: 'Associated with stars forming a path or river.'),
    //     CulturalSignificance(culture: 'Egyptian', interpretation: 'Possibly associated with the Nile.'),
    //   ],
    //   mainStars: [
    //     StarInfo(
    //         name: 'Achernar',
    //         designation: 'α Eri',
    //         magnitude: '0.45 (variable)',
    //         distance: '139 light-years',
    //         spectralType: 'B6Vpe'),
    //     StarInfo(
    //         name: 'Cursa',
    //         designation: 'β Eri',
    //         magnitude: '2.79 (variable)',
    //         distance: '90 light-years',
    //         spectralType: 'A3III'), // Near Rigel (Orion)
    //     StarInfo(
    //         name: 'Zaurak',
    //         designation: 'γ Eri',
    //         magnitude: '2.91 (variable)',
    //         distance: '203 light-years',
    //         spectralType: 'M0.5IIIb'),
    //     StarInfo(
    //         name: 'Rana', designation: 'δ Eri', magnitude: '3.52', distance: '29.5 light-years', spectralType: 'K0IV'),
    //     StarInfo(
    //         name: 'Epsilon Eridani',
    //         designation: 'ε Eri',
    //         magnitude: '3.73',
    //         distance: '10.5 light-years',
    //         spectralType: 'K2V'), // Nearby star with planets
    //   ],
    //   historicalBackground:
    //       'One of Ptolemy\'s 48 constellations. Originally ended further north before southern exploration extended it to include Achernar.',
    //   observationTips: [
    //     'Starts near Rigel in Orion (with the star Cursa).',
    //     'Winds its way southward in a long, meandering path.',
    //     'Achernar, its brightest star, is very far south and not visible from mid-northern latitudes.',
    //     'A generally faint constellation apart from Achernar and Cursa.',
    //     'Epsilon Eridani is a notable nearby star system for exoplanet interest.'
    //   ],
    // ),
  };

  static final List<ConstellationLevel> levels = [
    ConstellationLevel(
      name: 'Triangulum',
      requiredScore: 500,
      starPositions: const [
        Offset(0.21, 0.29),
        Offset(0.42, 0.17),
        Offset(0.78, 0.80),
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
        Offset(0.21, 0.33),
        Offset(0.34, 0.49),
        Offset(0.49, 0.48),
        Offset(0.60, 0.63),
        Offset(0.77, 0.50),
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
        Offset(0.64, 0.15),
        Offset(0.55, 0.26),
        Offset(0.48, 0.39),
        Offset(0.50, 0.56),
        Offset(0.60, 0.70),
        Offset(0.50, 0.76),
        Offset(0.40, 0.60),
      ],
      connections: const [
        [0, 1], // First handle segment
        [1, 2], // Second handle segment
        [2, 3], // Connection to the bowl
        [3, 4], // First bowl segment
        [4, 5], // Second bowl segment
        [5, 6], // Third bowl segment
        [6, 3], // Complete the bowl
      ],
      isClosedLoop: false,
    ),
    ConstellationLevel(
      name: 'Scorpius',
      requiredScore: 2000,
      starPositions: const [
        Offset(0.23, 0.45),
        Offset(0.18, 0.50),
        Offset(0.14, 0.54),
        Offset(0.21, 0.60),
        Offset(0.34, 0.61),
        Offset(0.44, 0.59),
        Offset(0.47, 0.50),
        Offset(0.49, 0.41),
        Offset(0.58, 0.29),
        Offset(0.62, 0.25),
        Offset(0.68, 0.23),
        Offset(0.83, 0.18),
        Offset(0.80, 0.12),
        Offset(0.82, 0.26),
        Offset(0.82, 0.32),
      ],
      connections: const [
        [12, 11],
        [11, 13],
        [13, 14],
        [11, 10],
        [10, 9],
        [9, 8],
        [8, 7],
        [7, 6],
        [6, 5],
        [5, 4],
        [4, 3],
        [3, 2],
        [2, 1],
        [1, 0]
      ],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Orion',
      requiredScore: 1500,
      starPositions: const [
        Offset(0.22, 0.20),
        Offset(0.28, 0.26),
        Offset(0.43, 0.19),
        Offset(0.51, 0.28),
        Offset(0.47, 0.45),
        Offset(0.43, 0.48),
        Offset(0.38, 0.50),
        Offset(0.33, 0.70),
        Offset(0.60, 0.66),
        Offset(0.79, 0.27),
        Offset(0.79, 0.21),
        Offset(0.74, 0.17),
        Offset(0.77, 0.37),
        Offset(0.72, 0.41),
      ],
      connections: const [
        [0, 1],
        [1, 2],
        [2, 3],
        [3, 4],
        [4, 5],
        [5, 6],
        [6, 1],
        [6, 7],
        [7, 8],
        [8, 4],
        [3, 9],
        [9, 10],
        [10, 11],
        [9, 12],
        [12, 13]
      ],
      isClosedLoop: false,
    ),

    // New levels...
    ConstellationLevel(
      name: "Lyra",
      requiredScore: 1750,
      starPositions: const [
        Offset(0.52, 0.15),
        Offset(0.64, 0.22),
        Offset(0.52, 0.32),
        Offset(0.37, 0.39),
        Offset(0.29, 0.74),
        Offset(0.44, 0.68),
      ],
      connections: const [
        [0, 1],
        [1, 2],
        [2, 0],
        [2, 3],
        [3, 4],
        [4, 5],
        [5, 2]
      ],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: "Cygnus",
      requiredScore: 2200,
      starPositions: const [
        Offset(0.38, 0.29),
        Offset(0.51, 0.45),
        Offset(0.35, 0.61),
        Offset(0.14, 0.71),
        Offset(0.73, 0.32),
        Offset(0.78, 0.15),
        Offset(0.66, 0.58),
        Offset(0.78, 0.72),
        Offset(0.86, 0.78),
      ],
      connections: const [
        [5, 4],
        [4, 1],
        [1, 2],
        [2, 3],
        [1, 0],
        [1, 6],
        [6, 7],
        [7, 8]
      ],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: "Perseus",
      requiredScore: 2500,
      starPositions: const [
        Offset(0.53, 0.11),
        Offset(0.53, 0.20),
        Offset(0.48, 0.18),
        Offset(0.39, 0.30),
        Offset(0.47, 0.30),
        Offset(0.60, 0.29),
        Offset(0.70, 0.25),
        Offset(0.89, 0.17),
        Offset(0.29, 0.36),
        Offset(0.16, 0.37),
        Offset(0.11, 0.35),
        Offset(0.11, 0.28),
        Offset(0.16, 0.29),
        Offset(0.20, 0.59),
        Offset(0.51, 0.54),
        Offset(0.54, 0.61),
        Offset(0.19, 0.72),
        Offset(0.22, 0.82),
        Offset(0.30, 0.81),
      ],
      connections: const [
        [0, 2],
        [2, 3],
        [3, 8],
        [8, 9],
        [9, 10],
        [10, 11],
        [11, 12],
        [3, 4],
        [4, 1],
        [1, 0],
        [4, 5],
        [5, 6],
        [6, 7],
        [4, 14],
        [14, 15],
        [8, 13],
        [13, 14],
        [13, 16],
        [16, 17],
        [17, 18]
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

    ConstellationLevel(
      name: 'Ursa Major',
      requiredScore: 1200,
      starPositions: const [
        Offset(0.14, 0.32),
        Offset(0.24, 0.27),
        Offset(0.32, 0.28),
        Offset(0.39, 0.29),
        Offset(0.54, 0.22),
        Offset(0.55, 0.32),
        Offset(0.43, 0.34),
        Offset(0.69, 0.25),
        Offset(0.81, 0.17),
        Offset(0.44, 0.43),
        Offset(0.51, 0.63),
        Offset(0.53, 0.47),
        Offset(0.70, 0.48),
        Offset(0.68, 0.53),
        Offset(0.71, 0.32),
        Offset(0.76, 0.34),
        Offset(0.88, 0.35),
        Offset(0.86, 0.39),
      ],
      connections: const [
        [0, 1],
        [1, 2],
        [2, 3],
        [3, 6],
        [6, 5],
        [5, 4],
        [4, 3],
        [4, 8],
        [8, 7],
        [7, 5],
        [7, 14],
        [14, 15],
        [15, 16],
        [15, 17],
        [6, 9],
        [9, 10],
        [9, 11],
        [11, 12],
        [11, 13]
      ],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Canis Major',
      requiredScore: 1600,
      starPositions: const [
        Offset(0.53, 0.14),
        Offset(0.45, 0.24),
        Offset(0.53, 0.28),
        Offset(0.64, 0.26),
        Offset(0.71, 0.34),
        Offset(0.81, 0.30),
        Offset(0.49, 0.48),
        Offset(0.57, 0.49),
        Offset(0.57, 0.65),
        Offset(0.47, 0.57),
        Offset(0.40, 0.60),
        Offset(0.34, 0.69),
      ],
      connections: const [
        [0, 1],
        [1, 2],
        [2, 3],
        [3, 0],
        [3, 4],
        [4, 5],
        [3, 6],
        [6, 9],
        [9, 8],
        [8, 7],
        [7, 4],
        [9, 10],
        [10, 11]
      ],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Taurus',
      requiredScore: 1900,
      starPositions: const [
        Offset(0.18, 0.22),
        Offset(0.42, 0.34),
        Offset(0.53, 0.46),
        Offset(0.55, 0.51),
        Offset(0.50, 0.52),
        Offset(0.10, 0.38),
        Offset(0.66, 0.58),
        Offset(0.84, 0.57),
        Offset(0.86, 0.63),
        Offset(0.90, 0.68),
        Offset(0.58, 0.66),
        Offset(0.64, 0.73),
      ],
      connections: const [
        [0, 1],
        [1, 2],
        [2, 3],
        [3, 4],
        [4, 5],
        [3, 6],
        [6, 7],
        [7, 8],
        [8, 9],
        [6, 10],
        [10, 11]
      ],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Leo',
      requiredScore: 2100,
      starPositions: const [
        Offset(0.87, 0.36),
        Offset(0.82, 0.32),
        Offset(0.69, 0.37),
        Offset(0.67, 0.45),
        Offset(0.74, 0.52),
        Offset(0.73, 0.62),
        Offset(0.35, 0.52),
        Offset(0.13, 0.52),
        Offset(0.37, 0.42),
      ],
      connections: const [
        [0, 1],
        [1, 2],
        [2, 3],
        [3, 4],
        [4, 5],
        [5, 6],
        [6, 7],
        [7, 8],
        [8, 3],
        [8, 6]
      ],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Andromeda',
      requiredScore: 2600,
      starPositions: const [
        Offset(0.90, 0.19),
        Offset(0.86, 0.26),
        Offset(0.78, 0.23),
        Offset(0.72, 0.37),
        Offset(0.66, 0.51),
        Offset(0.65, 0.58),
        Offset(0.85, 0.61),
        Offset(0.65, 0.71),
        Offset(0.60, 0.76),
        Offset(0.43, 0.51),
        Offset(0.49, 0.41),
        Offset(0.49, 0.34),
        Offset(0.35, 0.22),
        Offset(0.22, 0.21),
        Offset(0.24, 0.40),
        Offset(0.11, 0.38),
      ],
      connections: const [
        [0, 1],
        [1, 2],
        [1, 3],
        [3, 4],
        [4, 5],
        [5, 7],
        [7, 8],
        [6, 5],
        [5, 9],
        [9, 14],
        [14, 15],
        [9, 10],
        [10, 11],
        [11, 12],
        [12, 13]
      ],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Aquarius',
      requiredScore: 3100,
      starPositions: const [
        Offset(0.78, 0.11),
        Offset(0.55, 0.24),
        Offset(0.32, 0.36),
        Offset(0.49, 0.46),
        Offset(0.63, 0.46),
        Offset(0.31, 0.48),
        Offset(0.23, 0.49),
        Offset(0.22, 0.56),
        Offset(0.39, 0.76),
        Offset(0.44, 0.65),
        Offset(0.57, 0.65),
        Offset(0.70, 0.74),
      ],
      connections: const [],
      isClosedLoop: false,
    ),
    ConstellationLevel(
      name: 'Aquila',
      requiredScore: 3200,
      starPositions: const [
        Offset(0.28, 0.41),
        Offset(0.33, 0.32),
        Offset(0.39, 0.25),
        Offset(0.60, 0.52),
        Offset(0.82, 0.81),
        Offset(0.33, 0.60),
        Offset(0.14, 0.68),
        Offset(0.50, 0.69),
        Offset(0.79, 0.14),
        Offset(0.87, 0.09),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Aries',
      requiredScore: 3300,
      starPositions: const [
        Offset(0.16, 0.17),
        Offset(0.69, 0.50),
        Offset(0.83, 0.69),
        Offset(0.83, 0.77),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Auriga',
      requiredScore: 3400,
      starPositions: const [
        Offset(0.35, 0.10),
        Offset(0.33, 0.33),
        Offset(0.32, 0.52),
        Offset(0.51, 0.74),
        Offset(0.68, 0.62),
        Offset(0.54, 0.31),
        Offset(0.63, 0.35),
        Offset(0.64, 0.43),
        Offset(0.59, 0.42),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Boötes',
      requiredScore: 3500,
      starPositions: const [
        Offset(0.17, 0.07),
        Offset(0.11, 0.29),
        Offset(0.36, 0.45),
        Offset(0.64, 0.63),
        Offset(0.43, 0.33),
        Offset(0.38, 0.10),
        Offset(0.48, 0.83),
        Offset(0.80, 0.61),
        Offset(0.87, 0.67),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Cancer',
      requiredScore: 3600,
      starPositions: const [
        Offset(0.17, 0.21),
        Offset(0.35, 0.42),
        Offset(0.40, 0.52),
        Offset(0.42, 0.77),
        Offset(0.70, 0.61),
        Offset(0.86, 0.68),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Canis Minor',
      requiredScore: 3700,
      starPositions: const [
        Offset(0.26, 0.66),
        Offset(0.75, 0.27),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Capricornus',
      requiredScore: 3800,
      starPositions: const [
        Offset(0.18, 0.37),
        Offset(0.25, 0.39),
        Offset(0.36, 0.40),
        Offset(0.46, 0.41),
        Offset(0.79, 0.36),
        Offset(0.83, 0.30),
        Offset(0.74, 0.43),
        Offset(0.61, 0.61),
        Offset(0.55, 0.66),
        Offset(0.45, 0.59),
        Offset(0.34, 0.54),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Carina',
      requiredScore: 3900,
      starPositions: const [
        Offset(0.89, 0.39),
        Offset(0.60, 0.33),
        Offset(0.51, 0.45),
        Offset(0.36, 0.46),
        Offset(0.23, 0.54),
        Offset(0.19, 0.57),
        Offset(0.20, 0.63),
        Offset(0.31, 0.69),
        Offset(0.42, 0.65),
        Offset(0.33, 0.59),
        Offset(0.31, 0.53),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Centaurus',
      requiredScore: 4000,
      starPositions: const [
        Offset(0.23, 0.28),
        Offset(0.28, 0.23),
        Offset(0.38, 0.32),
        Offset(0.34, 0.34),
        Offset(0.46, 0.27),
        Offset(0.49, 0.21),
        Offset(0.67, 0.28),
        Offset(0.39, 0.36),
        Offset(0.38, 0.44),
        Offset(0.21, 0.37),
        Offset(0.09, 0.40),
        Offset(0.45, 0.54),
        Offset(0.65, 0.45),
        Offset(0.69, 0.49),
        Offset(0.78, 0.50),
        Offset(0.75, 0.54),
        Offset(0.84, 0.70),
        Offset(0.90, 0.61),
        Offset(0.41, 0.70),
        Offset(0.29, 0.74),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Crux',
      requiredScore: 4100,
      starPositions: const [
        Offset(0.60, 0.10),
        Offset(0.41, 0.83),
        Offset(0.20, 0.34),
        Offset(0.79, 0.37),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Draco',
      requiredScore: 4200,
      starPositions: const [
        Offset(0.08, 0.47),
        Offset(0.12, 0.54),
        Offset(0.18, 0.46),
        Offset(0.33, 0.29),
        Offset(0.39, 0.24),
        Offset(0.44, 0.34),
        Offset(0.37, 0.48),
        Offset(0.35, 0.58),
        Offset(0.34, 0.66),
        Offset(0.42, 0.71),
        Offset(0.42, 0.71),
        Offset(0.63, 0.71),
        Offset(0.82, 0.62),
        Offset(0.94, 0.59),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Hercules',
      requiredScore: 4400,
      starPositions: const [
        Offset(0.80, 0.14),
        Offset(0.74, 0.11),
        Offset(0.47, 0.14),
        Offset(0.72, 0.19),
        Offset(0.41, 0.30),
        Offset(0.57, 0.30),
        Offset(0.69, 0.26),
        Offset(0.71, 0.38),
        Offset(0.63, 0.40),
        Offset(0.78, 0.54),
        Offset(0.83, 0.59),
        Offset(0.45, 0.46),
        Offset(0.34, 0.44),
        Offset(0.40, 0.42),
        Offset(0.38, 0.55),
        Offset(0.33, 0.57),
        Offset(0.27, 0.55),
        Offset(0.17, 0.56),
        Offset(0.15, 0.61),
        Offset(0.58, 0.51),
        Offset(0.58, 0.69),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Libra',
      requiredScore: 4500,
      starPositions: const [
        Offset(0.24, 0.35),
        Offset(0.39, 0.28),
        Offset(0.54, 0.11),
        Offset(0.75, 0.32),
        Offset(0.64, 0.60),
        Offset(0.40, 0.67),
        Offset(0.38, 0.74),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Pisces',
      requiredScore: 4600,
      starPositions: const [
        Offset(0.40, 0.23),
        Offset(0.33, 0.29),
        Offset(0.36, 0.33),
        Offset(0.29, 0.46),
        Offset(0.22, 0.53),
        Offset(0.13, 0.63),
        Offset(0.19, 0.63),
        Offset(0.24, 0.60),
        Offset(0.29, 0.59),
        Offset(0.39, 0.57),
        Offset(0.45, 0.58),
        Offset(0.57, 0.56),
        Offset(0.81, 0.62),
        Offset(0.90, 0.61),
        Offset(0.97, 0.66),
        Offset(0.91, 0.72),
        Offset(0.82, 0.70),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Puppis',
      requiredScore: 4700,
      starPositions: const [
        Offset(0.14, 0.15),
        Offset(0.21, 0.08),
        Offset(0.28, 0.13),
        Offset(0.37, 0.17),
        Offset(0.59, 0.45),
        Offset(0.86, 0.62),
        Offset(0.80, 0.84),
        Offset(0.55, 0.66),
        Offset(0.31, 0.60),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Sagittarius',
      requiredScore: 4800,
      starPositions: const [
        Offset(0.22, 0.22),
        Offset(0.27, 0.22),
        Offset(0.34, 0.28),
        Offset(0.37, 0.25),
        Offset(0.44, 0.26),
        Offset(0.54, 0.33),
        Offset(0.40, 0.38),
        Offset(0.45, 0.43),
        Offset(0.65, 0.31),
        Offset(0.73, 0.20),
        Offset(0.70, 0.37),
        Offset(0.81, 0.40),
        Offset(0.92, 0.33),
        Offset(0.69, 0.49),
        Offset(0.74, 0.53),
        Offset(0.19, 0.39),
        Offset(0.13, 0.63),
        Offset(0.18, 0.66),
        Offset(0.20, 0.70),
        Offset(0.27, 0.76),
        Offset(0.41, 0.69),
        Offset(0.44, 0.75),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Vela',
      requiredScore: 4900,
      starPositions: const [
        Offset(0.18, 0.61),
        Offset(0.20, 0.56),
        Offset(0.25, 0.38),
        Offset(0.48, 0.28),
        Offset(0.61, 0.33),
        Offset(0.90, 0.44),
        Offset(0.76, 0.58),
        Offset(0.74, 0.63),
        Offset(0.57, 0.65),
        Offset(0.44, 0.66),
      ],
      connections: const [],
      isClosedLoop: false,
    ),

    ConstellationLevel(
      name: 'Virgo',
      requiredScore: 5000,
      starPositions: const [
        Offset(0.82, 0.10),
        Offset(0.80, 0.31),
        Offset(0.72, 0.39),
        Offset(0.60, 0.37),
        Offset(0.50, 0.54),
        Offset(0.68, 0.66),
        Offset(0.46, 0.28),
        Offset(0.37, 0.59),
        Offset(0.18, 0.73),
        Offset(0.30, 0.83),
        Offset(0.41, 0.75),
        Offset(0.49, 0.80),
      ],
      connections: const [],
      isClosedLoop: false,
    ),
    // ConstellationLevel(
    //     name: 'Eridanus', requiredScore: 4300, starPositions: const [], connections: const [], isClosedLoop: false),
  ];

  static ConstellationInfo getConstellationInfo(String name) {
    if (!constellations.containsKey(name)) {
      throw ArgumentError('Constellation $name not found');
    }
    return constellations[name]!;
  }

  static List<String> getAllConstellationNames() {
    return constellations.keys.toList();
  }
}
