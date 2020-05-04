import 'package:flutter/material.dart';
import 'package:Lifter/models/day.dart';

enum ExerciseType { Main, Accessory, Optional }

ExerciseType getExerciseTypeFromString(String type) {
  if (!type.contains('ExerciseType.')){
    type = 'ExerciseType.$type';
  }
  else {
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

  /// main, accessory, or optional
  final ExerciseType exerciseType;

  ExerciseBase({
    @required this.exerciseName,
    @required this.exerciseBaseId,
    @required this.exerciseType,
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

  Exercise({
    @required this.exerciseId,
    this.exerciseBase,
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
