import 'package:flutter/material.dart';
import 'package:Lifter/models/day.dart';

enum ExerciseType { main, accessory, optional }

ExerciseType getExerciseTypeFromString(String type) {
    type = 'ExerciseType.$type';
    return ExerciseType.values
        .firstWhere((f) => f.toString() == type, orElse: () => null);
  }

class ExerciseBase {
  final String exerciseName;
  final String exerciseBaseId;

  /// main, accessory, or optional
  final ExerciseType exerciseType;

  ExerciseBase({
    @required this.exerciseName,
    @required this.exerciseBaseId,
    @required this.exerciseType,
  });
}

class Exercise {
  final String exerciseId;
  final ExerciseBase exerciseBase;
  final Day day;
  final List<Set> sets;
  final String name;

  Exercise({
    @required this.exerciseId,
    @required this.exerciseBase,
    @required this.day,
    @required this.name,
    this.sets,
  });
  //  : super(exerciseName: exerciseBaseName, exerciseBaseId: exerciseBaseId);

  void startNew() {
    sets.forEach((set) => set.startNew());
  }
}

enum SetType { weight, percentOfMax, percentOfTMax }

class Set {
  int weight;
  String repRange;
  int reps;
  SetType setType;
  int percent;

  Set({
    this.weight,
    this.reps,
    this.setType,
    this.percent,
  });

  /// Reset weight and reps for this set.
  ///
  /// Can be used for starting new cycles without
  /// losing rep ranges and set types.
  void startNew() {
    this.weight = null;
    this.reps = null;
  }
}
