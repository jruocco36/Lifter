import 'package:Lifter/models/cycle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Lifter/models/day.dart';

enum ExerciseType { Main, Accessory, Optional }

ExerciseType getExerciseTypeFromString(String type) {
  if (!type.contains('ExerciseType.')) {
    type = 'ExerciseType.$type';
  }
  return ExerciseType.values
      .firstWhere((f) => f.toString() == type, orElse: () => null);
}

/// String values for each set type
List<String> exerciseTypesToStrings() {
  List<String> strings = [];
  ExerciseType.values.forEach((f) => strings.add(exerciseTypeToString(f)));
  return strings;
}

/// String value for set type
String exerciseTypeToString(ExerciseType type) {
  return type.toString().split('.').last;
}

/// Holds information about a base exercise.
///
/// Example {name: Bench, 1RM: 275}
class ExerciseBase {
  final String exerciseName;
  final String exerciseBaseId;
  double oneRepMax;
  List<Set> prHistory;

  /// main, accessory, or optional
  final ExerciseType exerciseType;

  /// Map of <cycleId, training max>
  Map<String, dynamic> cycleTMs;

  set cycleTM(Cycle cycle) {
    if (cycleTMs == null) cycleTMs = {};
    if (cycleTMs[cycle.cycleId] != null) return;
    cycleTMs[cycle.cycleId] =
        (((this.oneRepMax * cycle.trainingMaxPercent) / 5).roundToDouble() * 5)
            .clamp(0, this.oneRepMax);
  }

  void updateCycleTM(Cycle cycle, [double newTM]) {
    if (cycleTMs == null) cycleTMs = {};
    if (cycleTMs[cycle.cycleId] == null) return;
    if (newTM != null) {
      cycleTMs[cycle.cycleId] = newTM;
    } else {
      cycleTMs[cycle.cycleId] =
          (((this.oneRepMax * cycle.trainingMaxPercent) / 5).roundToDouble() *
                  5)
              .clamp(0, this.oneRepMax);
    }
  }

  String get type {
    return exerciseTypeToString(exerciseType);
  }

  // BUG: not adding to [prHistory], not updating set in db
  set pr(Set set) {
    // if (prHistory.firstWhere(
    //         (prSet) => prSet.weight == set.weight && prSet.reps == set.reps,
    //         orElse: null) ==
    //     null) {
    // prHistory.add(set);
    // }
  }

  ExerciseBase({
    @required this.exerciseName,
    @required this.exerciseBaseId,
    @required this.exerciseType,
    this.oneRepMax,
    this.cycleTMs,
    this.prHistory,
  });

  ExerciseBase.fromJson(DocumentSnapshot snapshot)
      : exerciseBaseId = snapshot.documentID,
        exerciseName = snapshot['name'],
        exerciseType = getExerciseTypeFromString(snapshot['type']),
        cycleTMs = snapshot['cycleTMs'],
        oneRepMax = snapshot['oneRepMax'],
        prHistory = snapshot['prHistory'];

  Map toJson({bool update}) => <String, dynamic>{
        'name': this.exerciseName,
        'type': this.type,
        'oneRepMax': this.oneRepMax,
        'cycleTMs': this.cycleTMs,
        if (this.prHistory != null)
          'sets':
              this.prHistory.map((set) => set.toJson(update: update)).toList(),
        if (!update) 'createdDate': Timestamp.now(),
      };
}

/// Holds information about an instance of a [ExerciseBase]
///
/// Example {exerciseBase: [ExerciseBase] Bench, day: [Day] day,
/// sets: List<[Set]> sets, name: Bench, trainingMax: 250}
class Exercise {
  final String exerciseId;
  ExerciseBase exerciseBase;
  final Day day;
  List<Set> sets;
  double trainingMax;

  String get name {
    return this.exerciseBase.exerciseName;
  }

  Exercise({
    @required this.exerciseId,
    @required this.exerciseBase,
    @required this.day,
    this.sets,
  }) : trainingMax = (exerciseBase != null && exerciseBase.cycleTMs != null
            ? exerciseBase.cycleTMs[day.week.cycle.cycleId]
            : null) {
    calculateTM();
  }

  void calculateSet(int index) {
    if (sets[index].setType == null || sets[index].setType == SetType.weight) {
      return;
    }
    if (sets[index].setType == SetType.percentOfMax) {
      sets[index].weight =
          ((sets[index].percent * this.exerciseBase.oneRepMax / 5)
                      .roundToDouble() *
                  5) +
              (sets[index].additionalWeight ?? 0);
    } else if (sets[index].setType == SetType.percentOfTMax) {
      sets[index].weight =
          ((sets[index].percent * this.trainingMax / 5).roundToDouble() * 5) +
              (sets[index].additionalWeight ?? 0);
    }
  }

  void calculateAllSets() {
    if (sets == null) return;
    sets.forEach((set) {
      if (set.setType == null || set.setType == SetType.weight) {
        return;
      }
      if (set.setType == SetType.percentOfMax) {
        set.weight =
            ((set.percent * this.exerciseBase.oneRepMax / 5).roundToDouble() *
                    5) +
                (set.additionalWeight ?? 0);
      } else if (set.setType == SetType.percentOfTMax) {
        set.weight =
            ((set.percent * this.trainingMax / 5).roundToDouble() * 5) +
                (set.additionalWeight ?? 0);
      }
    });
  }

  void calculateTM() {
    if (this.exerciseBase == null) return;
    this.exerciseBase.cycleTM = this.day.week.cycle;
    this.trainingMax = (exerciseBase != null && exerciseBase.cycleTMs != null
        ? exerciseBase.cycleTMs[day.week.cycle.cycleId]
        : null);
  }

  void updateTM(double trainingMax) {
    this.exerciseBase.updateCycleTM(day.week.cycle, trainingMax);
    this.trainingMax = (exerciseBase != null && exerciseBase.cycleTMs != null
        ? exerciseBase.cycleTMs[day.week.cycle.cycleId]
        : null);
    // could call [calculateSets()] here, but not sure if that is desired
    // could potentially recalculate weight for sets that have already been completed
  }

  void startNew() {
    sets.forEach((set) => set.startNew());
  }

  Exercise.fromJson(
      DocumentSnapshot snapshot, Day day, List<ExerciseBase> bases)
      : exerciseId = snapshot.documentID,
        exerciseBase = bases.firstWhere(
            (b) => b.exerciseBaseId == snapshot['exerciseBaseId'],
            orElse: null),
        day = day,
        // name = snapshot['name'],
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
        if (this.sets != null)
          'sets': this.sets.map((set) => set.toJson(update: update)).toList(),
        if (!update) 'createdDate': Timestamp.now(),
      };
}

///weight, percent of max, or percent of training max
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

String setTypeFormatString(String type) {
  if (type == 'weight')
    return 'Weight';
  else if (type == 'percentOfMax')
    return 'Percent of Max';
  else if (type == 'percentOfTMax')
    return 'Percent of Training Max';
  else
    return null;
}

/// Formatted strings for set types
List<String> setTypesToStrings() {
  List<String> strings = [];
  SetType.values.forEach((f) => strings.add(setTypeToString(f)));
  return strings;
}

class Set {
  double weight;
  String repRange;
  int reps;
  double percent;
  double additionalWeight;
  String notes;

  /// weight, percent of max, or percent of training max
  SetType setType;

  Set({
    this.weight,
    this.reps,
    this.setType = SetType.weight,
    this.percent,
    this.additionalWeight,
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
        weight: double.tryParse(json['weight'].toString()),
        reps: json['reps'],
        repRange: json['repRange'],
        setType: getSetTypeFromString(json['setType']),
        percent: json['percent'],
        notes: json['notes'],
        additionalWeight: double.tryParse(json['additionalWeight'].toString()),
      );

  Map toJson({bool update}) => <String, dynamic>{
        'weight': this.weight,
        'reps': this.reps,
        'repRange': this.repRange,
        'setType':
            setType != null ? this.setType.toString().split('.').last : null,
        'percent': this.percent,
        'notes': this.notes,
        'additionalWeight': this.additionalWeight,
        if (!update) 'createdDate': Timestamp.now(),
      };
}
