# 🌟 Constellation Catcher

Constellation Catcher is an interactive mobile game built with Flutter where players connect stars to trace constellations in the night sky. Through a combination of skill, timing, and pattern recognition, players recreate famous star patterns while learning about celestial mythology and astronomy.

## ✨ Features

- **Interactive Gameplay**: Connect stars in sequence to form constellations
- **Multiple Game Modes**: Easy, Normal, and Hard difficulties
- **Power-ups System**:
  - Time Freeze: Pause the timer for 5 seconds
  - Star Reveal: Show the correct path for 3 seconds
  - Path Clear: Remove decoy stars for 2 seconds
- **Achievement System**: Track your progress with various achievements
- **Visual Themes**: Multiple visual themes including Classic, Nebula, Aurora, and Deep Space
- **Progressive Difficulty**: Start with simple patterns and advance to complex constellations
- **Educational Content**: Learn about real constellations and their mythology

## 🎮 Game Mechanics

- **Star Connection**: Tap and drag between stars to create connections
- **Time Pressure**: Complete patterns within the time limit
- **Combo System**: Chain successful connections for score multipliers
- **Mistake Tolerance**: Three mistakes allowed per level
- **Score System**: Points awarded based on speed, accuracy, and difficulty

## 🛠️ Technical Details

### Prerequisites

- Flutter SDK >=3.5.4
- Dart SDK >=3.0.0

### Dependencies

Key packages used in this project:
```yaml
dependencies:
  flutter:
    sdk: flutter
  hooks_riverpod: ^2.5.1
  flutter_animate: ^4.1.0
  google_fonts: ^6.2.1
  drift: ^2.20.2
  shared_preferences: ^2.2.2
```

### Project Structure

```
lib/
├── components/         # Reusable UI components
├── config/            # Configuration files
├── data/             # Data models and services
├── models/           # Business logic models
├── provider/         # State management
└── screens/          # App screens
```

## 🚀 Getting Started

1. Clone the repository:
```bash
git clone https://github.com/TaalayDev/constellation_catcher.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🎯 Game Levels

The game includes several constellation patterns:
- Triangulum (Easy): Simple three-star pattern
- Cassiopeia (Medium): Five-star W-shaped pattern
- Ursa Minor (Medium): Seven-star Little Dipper
- Scorpius (Hard): Complex nine-star pattern
- Orion (Expert): Challenging twelve-star pattern

## 🎨 Themes

- **Classic**: Traditional starfield look
- **Nebula**: Purple and pink cosmic clouds
- **Aurora**: Green northern lights effect
- **Deep Space**: Dark blue with distant galaxies

## 🏆 Achievements

Players can earn various achievements:
- Stargazer: Complete your first constellation
- Constellation Master: Complete all constellations
- Speed Demon: Complete a constellation in under 10 seconds
- Perfect Draw: Complete a constellation without mistakes
- Star Collector: Connect 100 stars total

## 📱 Platform Support

- iOS
- Android
- Web (experimental)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🙏 Acknowledgments

- Constellation mythology sourced from various astronomical databases
- Flutter and Dart community