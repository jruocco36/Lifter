import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Lifter/models/day.dart';

// TODO: populate 1RM and TM

enum ExerciseType { Main, Accessory, Optional }

ExerciseType getExerciseTypeFromString(String type) {
  if (!type.contains('ExerciseType.')) {
    type = 'ExerciseType.$type';
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
  final double oneRepMax;

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

  Map toJson({bool update}) => <String, dynamic>{
        'name': this.exerciseName,
        'type': this.type,
        'oneRepMax': this.oneRepMax,
        if (!update) 'createdDate': Timestamp.now(),
      };
}

class Exercise {
  final String exerciseId;
  final ExerciseBase exerciseBase;
  final Day day;
  List<Set> sets;
  final String name;
  final double trainingMax;

  Exercise({
    @required this.exerciseId,
    @required this.exerciseBase,
    @required this.day,
    @required this.name,
    this.sets,
  }) : trainingMax = (exerciseBase != null
            ? exerciseBase.oneRepMax != null
                ? exerciseBase.oneRepMax * day.week.cycle.trainingMaxPercent
                : null
            : null);

  void setTrainingMax() {}

  void startNew() {
    sets.forEach((set) => set.startNew());
  }

  Exercise.fromJson(
      DocumentSnapshot snapshot, Day day, List<ExerciseBase> bases)
      : exerciseId = snapshot.documentID,
        exerciseBase = bases
            .firstWhere((b) => b.exerciseBaseId == snapshot['exerciseBaseId']),
        day = day,
        name = snapshot['name'],
        trainingMax = snapshot['trainingMax'],
        sets = snapshot['sets'] != null
            ? List<Set>.from(
                snapshot['sets'].map(
                  (set) {
                    return Set.fromJson(set);
                  },
                ),
              )
            : null;

  Map toJson({bool update, String baseId}) => <String, dynamic>{
        'exerciseBaseId':
            baseId != null ? baseId : this.exerciseBase.exerciseBaseId,
        'dayId': this.day.dayId,
        'name': this.name,
        'trainingMax': this.trainingMax,
        'sets': this.sets != null
            ? this.sets.map((set) => set.toJson(update: update)).toList()
            : null,
        if (!update) 'createdDate': Timestamp.now(),
      };
}

enum SetType { weight, percentOfMax, percentOfTMax }

SetType getSetTypeFromString(String type) {
  if (type == null) return null;
  if (!type.contains('SetType.')) {
    type = 'SetType.$type';
  }
  return SetType.values
      .firstWhere((f) => f.toString() == type, orElse: () => null);
}

String setTypeToString(SetType type) {
  return type.toString().split('.').last;
}

class Set {
  double weight;
  String repRange;
  int reps;
  double percent;
  String notes;

  /// weight, percent of max, percent of training max
  SetType setType;

  Set({
    this.weight,
    this.reps,
    this.setType,
    this.percent,
    this.repRange,
    this.notes,
  });

  /// Reset weight and reps for this set.
  ///
  /// Can be used for starting new cycles without
  /// losing rep ranges and set types.
  void startNew() {
    this.weight = null;
    this.reps = null;
  }

  @override
  String toString() {
    return 'Weight: ' + weight.toString() + ' reps: ' + reps.toString();
  }

  String get type {
    return setTypeToString(setType);
  }

  factory Set.fromJson(Map<String, dynamic> json) => Set(
        weight: json['weight'],
        reps: json['reps'],
        repRange: json['repRange'],
        setType: getSetTypeFromString(json['setType']),
        percent: json['percent'],
        notes: json['notes'],
      );

  Map toJson({bool update}) => <String, dynamic>{
        'weight': this.weight,
        'reps': this.reps,
        'repRange': this.repRange,
        'setType':
            setType != null ? this.setType.toString().split('.').last : null,
        'percent': this.percent,
        'notes': this.notes,
        if (!update) 'createdDate': Timestamp.now(),
      };
}
