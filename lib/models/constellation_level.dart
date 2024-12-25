import 'dart:ui';

import 'package:equatable/equatable.dart';

class ConstellationLevel extends Equatable {
  final List<Offset> starPositions;
  final int requiredScore;
  final String name;
  final bool isClosedLoop;
  final List<List<int>> connections;

  ConstellationLevel({
    required this.starPositions,
    required this.requiredScore,
    required this.name,
    required this.isClosedLoop,
    List<List<int>>? connections,
  }) : connections =
            connections ?? List.generate(starPositions.length, (index) => []);

  @override
  List<Object?> get props =>
      [starPositions, requiredScore, name, isClosedLoop, connections];
}
