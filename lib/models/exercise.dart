import 'package:flutter/material.dart';
import 'package:Lifter/models/day.dart';

// TODO: populate 1RM and TM

enum ExerciseType { Main, Accessory, Optional }

ExerciseType getExerciseTypeFromString(String type) {
  if (!type.contains('ExerciseType.')) {
    type = 'ExerciseType.$type';
  } else {
    type = '$type';
  }
  return ExerciseType.values
      .firstWhere((f) => f.toString() == type, orElse: () => null);
}

List<String> exercistTypesToStrings() {
  List<String> strings = [];
  ExerciseType.values.forEach((f) => strings.add(exerciseTypeToString(f)));
  return strings;
}

String exerciseTypeToString(ExerciseType type) {
  return type.toString().split('.').last;
}

class ExerciseBase {
  final String exerciseName;
  final String exerciseBaseId;
  final int oneRepMax;

  /// main, accessory, or optional
  final ExerciseType exerciseType;

  ExerciseBase({
    @required this.exerciseName,
    @required this.exerciseBaseId,
    @required this.exerciseType,
    this.oneRepMax,
  });

  String get type {
    return exerciseTypeToString(exerciseType);
  }
}

class Exercise {
  final String exerciseId;
  final ExerciseBase exerciseBase;
  final Day day;
  final List<Set> sets;
  final String name;
  final int trainingMax;

  Exercise({
    @required this.exerciseId,
    @required this.exerciseBase,
    @required this.day,
    @required this.name,
    this.sets,
  }) : trainingMax =
            (exerciseBase != null 
            ? exerciseBase.oneRepMax != null
            ? exerciseBase.oneRepMax * day.week.cycle.trainingMaxPercent
            : null
            : null);

  void setTrainingMax() {}

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
