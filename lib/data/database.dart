import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart' show IconData, Icons;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class PlayerAchievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get iconName => text()();
  TextColumn get rarity => text()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  IntColumn get total => integer()();
  BoolColumn get unlocked => boolean().withDefault(const Constant(false))();
}

class PlayerStats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  IntColumn get value => integer()();
}

@DriftDatabase(tables: [PlayerAchievements, PlayerStats])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedInitialData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Add future migration logic here
      },
    );
  }

  Future<void> _seedInitialData() async {
    // Seed achievements
    await batch((batch) {
      batch.insertAll(playerAchievements, [
        PlayerAchievementsCompanion.insert(
          name: 'Stargazer',
          description: 'Complete your first constellation',
          iconName: 'auto_awesome_rounded',
          rarity: 'common',
          total: 1,
        ),
        PlayerAchievementsCompanion.insert(
          name: 'Constellation Master',
          description: 'Complete all constellations',
          iconName: 'stars_rounded',
          rarity: 'legendary',
          total: 5,
        ),
        PlayerAchievementsCompanion.insert(
          name: 'Speed Demon',
          description: 'Complete a constellation in under 10 seconds',
          iconName: 'speed_rounded',
          rarity: 'rare',
          total: 1,
        ),
        PlayerAchievementsCompanion.insert(
          name: 'Perfect Draw',
          description: 'Complete a constellation without any mistakes',
          iconName: 'gesture_rounded',
          rarity: 'epic',
          total: 5,
        ),
        PlayerAchievementsCompanion.insert(
          name: 'Star Collector',
          description: 'Connect 100 stars total',
          iconName: 'catching_pokemon_rounded',
          rarity: 'rare',
          total: 100,
        ),
        PlayerAchievementsCompanion.insert(
          name: 'Night Owl',
          description: 'Play the game for 1 hour total',
          iconName: 'nights_stay_rounded',
          rarity: 'common',
          total: 60,
        ),
        PlayerAchievementsCompanion.insert(
          name: 'Celestial Sage',
          description: 'Use the hints feature 10 times',
          iconName: 'lightbulb_rounded',
          rarity: 'uncommon',
          total: 10,
        ),
        PlayerAchievementsCompanion.insert(
          name: 'Cosmic Explorer',
          description: 'Complete a constellation on hard difficulty',
          iconName: 'explore_rounded',
          rarity: 'rare',
          total: 1,
        ),
      ]);
    });

    // Seed initial player stats
    await batch((batch) {
      batch.insertAll(playerStats, [
        PlayerStatsCompanion.insert(
          key: 'totalStarsConnected',
          value: 0,
        ),
        PlayerStatsCompanion.insert(
          key: 'totalPlayTime',
          value: 0,
        ),
        PlayerStatsCompanion.insert(
          key: 'highScore',
          value: 0,
        ),
        PlayerStatsCompanion.insert(
          key: 'perfectDraws',
          value: 0,
        ),
        PlayerStatsCompanion.insert(
          key: 'totalConstellationsCompleted',
          value: 0,
        ),
      ]);
    });
  }

  // Achievement methods
  Stream<List<PlayerAchievement>> watchAchievements() =>
      select(playerAchievements).watch();

  Future<List<PlayerAchievement>> getAllAchievements() =>
      select(playerAchievements).get();

  Future<void> updateAchievementProgress(String name, int progress) async {
    final achievement = await (select(playerAchievements)
          ..where((a) => a.name.equals(name)))
        .getSingle();

    await (update(playerAchievements)..where((a) => a.name.equals(name)))
        .write(PlayerAchievementsCompanion(
      progress: Value(progress),
      unlocked: Value(progress >= achievement.total),
    ));
  }

  // Stats methods
  Stream<List<PlayerStat>> watchAllStats() => select(playerStats).watch();

  Future<int> getStat(String key) async {
    final stat = await (select(playerStats)..where((s) => s.key.equals(key)))
        .getSingle();
    return stat.value;
  }

  Future<void> incrementStat(String key, [int amount = 1]) async {
    final currentValue = await getStat(key);
    await (update(playerStats)..where((s) => s.key.equals(key)))
        .write(PlayerStatsCompanion(value: Value(currentValue + amount)));
  }

  Future<void> setStat(String key, int value) =>
      (update(playerStats)..where((s) => s.key.equals(key)))
          .write(PlayerStatsCompanion(value: Value(value)));
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'constellation_catcher.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

extension PlayerAchievementX on PlayerAchievement {
  IconData get icon {
    switch (iconName) {
      case 'auto_awesome_rounded':
        return Icons.auto_awesome_rounded;
      case 'stars_rounded':
        return Icons.stars_rounded;
      case 'speed_rounded':
        return Icons.speed_rounded;
      case 'gesture_rounded':
        return Icons.gesture_rounded;
      case 'catching_pokemon_rounded':
        return Icons.catching_pokemon_rounded;
      case 'nights_stay_rounded':
        return Icons.nights_stay_rounded;
      case 'lightbulb_rounded':
        return Icons.lightbulb_rounded;
      case 'explore_rounded':
        return Icons.explore_rounded;
      default:
        return Icons.error;
    }
  }
}
