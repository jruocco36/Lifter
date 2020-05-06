import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/day.dart';
import 'package:Lifter/models/program.dart';
import 'package:Lifter/models/week.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// TODO: look into transactions/batched write

class DatabaseService {
  // current user's id
  final String uid;
  final DocumentReference userRef;
  DatabaseService({this.uid})
      : userRef = Firestore.instance.collection('users').document(uid);

  // update this user data for this user
  Future updateUser(Timestamp createdDate) async {
    return await userRef.setData({
      'createdDate': createdDate,
    });
  }

  // update a program for this user
  Future updateProgram(String programId, String programName, String programType,
      String progressType, Timestamp createdDate) async {
    return await userRef
        .collection('programs')
        .document(programId ?? null)
        .setData({
      'programName': programName,
      'programType': programType,
      'progressType': progressType,
      'createdDate': createdDate,
    });
  }

  // delete a program for this user
  Future deleteProgram(String programId) async {
    return await userRef.collection('programs').document(programId).delete();
  }

  // program list from snapshot
  List<Program> _programListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Program(
        uid: uid,
        programId: doc.documentID,
        name: doc['programName'],
        programType: doc['programType'],
        progressType: doc['progressType'],
        createdDate: doc['createdDate'],
      );
    }).toList();
  }

  // get programs stream
  Stream<List<Program>> get programs {
    return userRef
        .collection('programs')
        .orderBy('createdDate')
        .snapshots()
        .map(_programListFromSnapshot);
  }

  // program data from snapshot
  Program _programDataFromSnapshot(DocumentSnapshot snapshot) {
    return Program(
      uid: uid,
      programId: snapshot.documentID,
      name: snapshot.data['programName'],
      programType: snapshot.data['programType'],
      progressType: snapshot.data['progressType'],
      createdDate: snapshot.data['createdDate'],
    );
  }

  // get program data stream for specific program id
  Stream<Program> getProgramData(String programId) {
    return userRef
        .collection('programs')
        .document(programId)
        .snapshots()
        .map(_programDataFromSnapshot);
  }

  // program's cycle data from snapshot
  List<Cycle> _cycleListFromSnapshot(QuerySnapshot snapshot, Program program) {
    return snapshot.documents.map((doc) {
      return _cycleDataFromSnapshot(doc, program);
    }).toList();
  }

  // get stream for program's cycles
  Stream<List<Cycle>> getCycles(Program program) {
    return userRef
        .collection('programs')
        .document(program.programId)
        .collection('cycles')
        .snapshots()
        .map((snapshot) => _cycleListFromSnapshot(snapshot, program));
  }

  // program data from snapshot
  Cycle _cycleDataFromSnapshot(DocumentSnapshot snapshot, Program program) {
    return Cycle(
      program: program,
      cycleId: snapshot.documentID,
      name: snapshot['cycleName'],
      startDate: snapshot['startDate'].toDate(),
      trainingMaxPercent: snapshot['trainingMaxPercent'].toDouble(),
    );
  }

  // get cycle data stream for specific program id and cycle id
  Stream<Cycle> getCycleData(Program program, String cycleId) {
    return userRef
        .collection('programs')
        .document(program.programId)
        .collection('cycles')
        .document(cycleId)
        .snapshots()
        .map((snapshot) => _cycleDataFromSnapshot(snapshot, program));
  }

  // update a cycle
  Future updateCycle(String programId, String cycleId, String cycleName,
      DateTime startDate, double trainingMaxPercent) async {
    return await userRef
        .collection('programs')
        .document(programId)
        .collection('cycles')
        .document(cycleId)
        .setData({
      'uid': uid,
      'programId': programId,
      'cycleName': cycleName,
      'startDate': Timestamp.fromDate(startDate),
      'trainingMaxPercent': trainingMaxPercent,
    });
  }

  // delete a cycle
  Future deleteCycle(String programId, String cycleId) async {
    return await userRef
        .collection('programs')
        .document(programId)
        .collection('cycles')
        .document(cycleId)
        .delete();
  }

  // program's week data from snapshot
  List<Week> _weekListFromSnapshot(QuerySnapshot snapshot, Cycle cycle) {
    return snapshot.documents.map((doc) {
      return _weekDataFromSnapshot(doc, cycle);
    }).toList();
  }

  // get stream for cycle's weeks
  Stream<List<Week>> getWeeks(Cycle cycle) {
    return userRef
        .collection('programs')
        .document(cycle.program.programId)
        .collection('cycles')
        .document(cycle.cycleId)
        .collection('weeks')
        .orderBy('startDate')
        .snapshots()
        .map((snapshot) => _weekListFromSnapshot(snapshot, cycle));
  }

  // delete a week
  Future deleteWeek(String programId, String cycleId, String weekId) async {
    return await userRef
        .collection('programs')
        .document(programId)
        .collection('cycles')
        .document(cycleId)
        .collection('weeks')
        .document(weekId)
        .delete();
  }

  // week data from snapshot
  Week _weekDataFromSnapshot(DocumentSnapshot snapshot, Cycle cycle) {
    return Week(
      cycle: cycle,
      weekId: snapshot.documentID,
      weekName: snapshot['weekName'],
      startDate: snapshot['startDate'].toDate(),
      days: snapshot['days'],
    );
  }

  // get week data stream for specific program id and cycle id
  Stream<Week> getWeekData(Cycle cycle, String weekId) {
    return userRef
        .collection('programs')
        .document(cycle.program.programId)
        .collection('cycles')
        .document(cycle.cycleId)
        .collection('weeks')
        .document(weekId)
        .snapshots()
        .map((snapshot) => _weekDataFromSnapshot(snapshot, cycle));
  }

  // update a week
  Future updateWeek(String programId, String cycleId, String weekId,
      String weekName, DateTime startDate, Map<String, dynamic> days) async {
    if (days == null) {
      days = days = {
        'Monday': null,
        'Tuesday': null,
        'Wednesday': null,
        'Thursday': null,
        'Friday': null,
        'Saturday': null,
        'Sunday': null,
      };
    }
    return await userRef
        .collection('programs')
        .document(programId)
        .collection('cycles')
        .document(cycleId)
        .collection('weeks')
        .document(weekId)
        .setData({
      'uid': uid,
      'programId': programId,
      'cycleId': cycleId,
      'weekName': weekName,
      'startDate': Timestamp.fromDate(startDate),
      'days': days,
    });
  }

  // day data from snapshot
  Day _dayDataFromSnapshot(DocumentSnapshot snapshot, Week week) {
    return Day(
      date: snapshot['date'].toDate(),
      bodyweight: snapshot['bodyweight'],
      week: week,
      dayId: snapshot.documentID,
      dayName: snapshot['dayName'],
    );
  }

  // program's day data from snapshot
  List<Day> _dayListFromSnapshot(QuerySnapshot snapshot, Week week) {
    return snapshot.documents.map((doc) {
      return _dayDataFromSnapshot(doc, week);
    }).toList();
  }

  // get stream for week's days
  Stream<List<Day>> getDays(Week week) {
    return userRef
        .collection('programs')
        .document(week.cycle.program.programId)
        .collection('cycles')
        .document(week.cycle.cycleId)
        .collection('weeks')
        .document(week.weekId)
        .collection('days')
        .orderBy('date')
        .snapshots()
        .map((snapshot) => _dayListFromSnapshot(snapshot, week));
  }

  // delete a day
  Future deleteDay(Day day) async {
    return await userRef
        .collection('programs')
        .document(day.week.cycle.program.programId)
        .collection('cycles')
        .document(day.week.cycle.cycleId)
        .collection('weeks')
        .document(day.week.weekId)
        .collection('days')
        .document(day.dayId)
        .delete()
        .whenComplete(() {
      day.week.days[DateFormat('EEEE').format(day.date)] = null;
      updateWeek(
          day.week.cycle.program.programId,
          day.week.cycle.cycleId,
          day.week.weekId,
          day.week.weekName,
          day.week.startDate,
          day.week.days);
    });
  }

  // get day data stream for specific program id and cycle id
  Stream<Day> getDayData(Week week, String dayId) {
    return userRef
        .collection('programs')
        .document(week.cycle.program.programId)
        .collection('cycles')
        .document(week.cycle.cycleId)
        .collection('weeks')
        .document(week.weekId)
        .collection('days')
        .document(dayId)
        .snapshots()
        .map((snapshot) => _dayDataFromSnapshot(snapshot, week));
  }

  // update a day
  Future updateDay(
      Week week, String dayId, DateTime date, double bodyweight, String dayName,
      [bool merge]) async {
    if (dayId == null) {
      return await userRef
          .collection('programs')
          .document(week.cycle.program.programId)
          .collection('cycles')
          .document(week.cycle.cycleId)
          .collection('weeks')
          .document(week.weekId)
          .collection('days')
          .add({
        'uid': uid,
        'programId': week.cycle.program.programId,
        'cycleId': week.cycle.cycleId,
        'weekId': week.weekId,
        'dayName': dayName,
        'date': date,
        'bodyweight': bodyweight,
      }).then((doc) {
        week.days[DateFormat('EEEE').format(date)] = doc.documentID;
        updateWeek(week.cycle.program.programId, week.cycle.cycleId,
            week.weekId, week.weekName, week.startDate, week.days);
      });
    } else {
      return await userRef
          .collection('programs')
          .document(week.cycle.program.programId)
          .collection('cycles')
          .document(week.cycle.cycleId)
          .collection('weeks')
          .document(week.weekId)
          .collection('days')
          .document(dayId)
          .setData({
        'uid': uid,
        'programId': week.cycle.program.programId,
        'cycleId': week.cycle.cycleId,
        'weekId': week.weekId,
        'dayName': dayName,
        'date': date,
        'bodyweight': bodyweight,
      }, merge: true).whenComplete(() {
        String val = week.days.keys
            .firstWhere((k) => week.days[k] == dayId, orElse: null);
        week.days[val] = null;
        week.days[DateFormat('EEEE').format(date)] = dayId;
        updateWeek(week.cycle.program.programId, week.cycle.cycleId,
            week.weekId, week.weekName, week.startDate, week.days);
      });
    }
  }

  // exerciseBase data from snapshot
  ExerciseBase _exerciseBaseDataFromSnapshot(DocumentSnapshot snapshot) {
    return ExerciseBase(
      exerciseBaseId: snapshot.documentID,
      exerciseName: snapshot.data['name'],
      exerciseType: getExerciseTypeFromString(snapshot.data['type']),
    );
  }

  // program's exerciseBase data from snapshot
  List<ExerciseBase> _exerciseBaseListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return _exerciseBaseDataFromSnapshot(doc);
    }).toList();
  }

  // get stream exerciseBases
  Stream<List<ExerciseBase>> getExerciseBases() {
    return userRef
        .collection('exerciseBases')
        .snapshots()
        .map((snapshot) => _exerciseBaseListFromSnapshot(snapshot));
  }

  // update a base exercise
  Future updateExercise(ExerciseBase exerciseBase, Exercise exercise) async {
    bool update = exercise.exerciseId != null;
    if (exerciseBase.exerciseBaseId == null) {
      return await userRef
          .collection('exerciseBases')
          .add(exerciseBase.toJson(update: false))
          .then((doc) {
        userRef
            .collection('programs')
            .document(exercise.day.week.cycle.program.programId)
            .collection('cycles')
            .document(exercise.day.week.cycle.cycleId)
            .collection('weeks')
            .document(exercise.day.week.weekId)
            .collection('days')
            .document(exercise.day.dayId)
            .collection('exercises')
            .add(exercise.toJson(
                update: false, baseId: doc.documentID));
      });
    } else {
      return await userRef
          .collection('exerciseBases')
          .document(exerciseBase.exerciseBaseId)
          .setData({
        'name': exerciseBase.exerciseName,
        'type': exerciseBase.type,
      }, merge: true).whenComplete(() {
        userRef
            .collection('programs')
            .document(exercise.day.week.cycle.program.programId)
            .collection('cycles')
            .document(exercise.day.week.cycle.cycleId)
            .collection('weeks')
            .document(exercise.day.week.weekId)
            .collection('days')
            .document(exercise.day.dayId)
            .collection('exercises')
            .document(exercise.exerciseId)
            .setData(exercise.toJson(update: update), merge: true);
      });
    }
  }

  // exercise data from snapshot
  Exercise _exerciseDataFromSnapshot(
      DocumentSnapshot snapshot, Day day, List<ExerciseBase> bases) {
    return Exercise.fromJson(snapshot, day, bases);
  }

  // program's exercise data from snapshot
  List<Exercise> _exerciseListFromSnapshot(
      QuerySnapshot snapshot, Day day, List<ExerciseBase> bases) {
    return snapshot.documents.map((doc) {
      return _exerciseDataFromSnapshot(doc, day, bases);
    }).toList();
  }

  // get stream for week's exercises
  Stream<List<Exercise>> getExercises(Day day, List<ExerciseBase> bases) {
    if (bases.isEmpty) {
      return null;
    }
    return userRef
        .collection('programs')
        .document(day.week.cycle.program.programId)
        .collection('cycles')
        .document(day.week.cycle.cycleId)
        .collection('weeks')
        .document(day.week.weekId)
        .collection('days')
        .document(day.dayId)
        .collection('exercises')
        .orderBy('createdDate')
        .snapshots()
        .map((snapshot) => _exerciseListFromSnapshot(snapshot, day, bases));
  }

  // get exercise data stream for specific program id and cycle id
  Stream<Exercise> getExerciseData(
      Day day, String exerciseId, List<ExerciseBase> bases) {
    return userRef
        .collection('programs')
        .document(day.week.cycle.program.programId)
        .collection('cycles')
        .document(day.week.cycle.cycleId)
        .collection('weeks')
        .document(day.week.weekId)
        .collection('days')
        .document(day.dayId)
        .collection('exercises')
        .document(exerciseId)
        .snapshots()
        .map((snapshot) => _exerciseDataFromSnapshot(snapshot, day, bases));
  }

  // delete an exercise from a day
  Future deleteExercise(Exercise exercise) async {
    return await userRef
        .collection('programs')
        .document(exercise.day.week.cycle.program.programId)
        .collection('cycles')
        .document(exercise.day.week.cycle.cycleId)
        .collection('weeks')
        .document(exercise.day.week.weekId)
        .collection('days')
        .document(exercise.day.dayId)
        .collection('exercises')
        .document(exercise.exerciseId)
        .delete();
  }
}
