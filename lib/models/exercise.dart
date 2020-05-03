import 'package:flutter/material.dart';
import 'package:Lifter/models/day.dart';

// class ExerciseBase {
//   final String exerciseName;
//   final String exerciseBaseId;

//   ExerciseBase({
//     @required this.exerciseName,
//     @required this.exerciseBaseId,
//   });
// }

class Exercise {
  final Day day;
  final String exerciseId;
  final List<Set> sets;
  final String name;

  Exercise({
    // @required String exerciseBaseName,
    // @required String exerciseBaseId,
    @required this.day,
    @required this.exerciseId,
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
