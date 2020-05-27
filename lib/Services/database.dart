import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/day.dart';
import 'package:Lifter/models/program.dart';
import 'package:Lifter/models/week.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// TODO: rewrite all updates/adds to Class.toJson/Class.fromJson similar to exercise
// TODO: rewrite all forms to update an instance of object and send object to [DatabaseService]

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
        .orderBy('startDate')
        .snapshots()
        .map((snapshot) => _cycleListFromSnapshot(snapshot, program));
  }

  // program data from snapshot
  Cycle _cycleDataFromSnapshot(DocumentSnapshot snapshot, Program program) {
    return Cycle.fromJson(snapshot, program);
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
  Future updateCycle(Cycle cycle) async {
    bool update = cycle.cycleId != null;
    if (update) {
      return await userRef
          .collection('programs')
          .document(cycle.program.programId)
          .collection('cycles')
          .document(cycle.cycleId)
          .updateData(cycle.toJson(update: update));
    } else {
      return await userRef
          .collection('programs')
          .document(cycle.program.programId)
          .collection('cycles')
          .add(cycle.toJson(update: update));
    }
  }

  // delete a cycle
  Future deleteCycle(String programId, String cycleId) async {
    userRef.collection('exerciseBases').getDocuments().then((docs) {
      docs.documents.forEach((doc) {
        Map<String, dynamic> tMs = doc.data['cycleTMs'];
        if (tMs[cycleId] != null) {
          tMs.remove(cycleId);
        }
        doc.reference.updateData({'cycleTMs': tMs});
      });
    });

    // create batch to store commands
    var batch = Firestore.instance.batch();

    DocumentReference cycleRef = userRef
        .collection('programs')
        .document(programId)
        .collection('cycles')
        .document(cycleId);

    // delete cycle ref first so cycle disappears immediately
    // then continue cleaning up subcollections in background
    cycleRef.delete();

    QuerySnapshot weekCol = await cycleRef.collection('weeks').getDocuments();
    for (DocumentSnapshot weekDoc in weekCol.documents) {
      QuerySnapshot dayCol =
          await weekDoc.reference.collection('days').getDocuments();
      for (DocumentSnapshot dayDoc in dayCol.documents) {
        QuerySnapshot exCol =
            await dayDoc.reference.collection('exercises').getDocuments();
        for (DocumentSnapshot exDoc in exCol.documents) {
          batch.delete(exDoc.reference);
        }
        batch.delete(dayDoc.reference);
      }
      batch.delete(weekDoc.reference);
    }

    // batch.delete(cycleRef);
    return batch.commit(); // commit batch to db
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

  Future<List<Week>> getWeekList(Cycle cycle) {
    if (cycle == null) return null;
    return userRef
        .collection('programs')
        .document(cycle.program.programId)
        .collection('cycles')
        .document(cycle.cycleId)
        .collection('weeks')
        .orderBy('startDate')
        .getDocuments()
        .then((snapshot) => _weekListFromSnapshot(snapshot, cycle));
  }

  // delete a week and all subcollections
  Future deleteWeek(String programId, String cycleId, String weekId) async {
    var batch = Firestore.instance.batch();

    DocumentReference weekRef = userRef
        .collection('programs')
        .document(programId)
        .collection('cycles')
        .document(cycleId)
        .collection('weeks')
        .document(weekId);

    // delete weekRef ref first so cycle disappears immediately
    // then continue cleaning up subcollections in background
    weekRef.delete();

    QuerySnapshot dayCol = await weekRef.collection('days').getDocuments();
    for (DocumentSnapshot dayDoc in dayCol.documents) {
      QuerySnapshot exCol =
          await dayDoc.reference.collection('exercises').getDocuments();
      for (DocumentSnapshot exDoc in exCol.documents) {
        batch.delete(exDoc.reference);
      }
      batch.delete(dayDoc.reference);
    }

    // batch.delete(weekRef);
    batch.commit();
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
  Future updateWeek(Week week) async {
    bool update = week.weekId != null;

    if (week.days == null) {
      week.days = week.days = {
        'Monday': null,
        'Tuesday': null,
        'Wednesday': null,
        'Thursday': null,
        'Friday': null,
        'Saturday': null,
        'Sunday': null,
      };
    }

    if (update) {
      return await userRef
          .collection('programs')
          .document(week.cycle.program.programId)
          .collection('cycles')
          .document(week.cycle.cycleId)
          .collection('weeks')
          .document(week.weekId)
          .updateData(week.toJson());
    } else {
      return await userRef
          .collection('programs')
          .document(week.cycle.program.programId)
          .collection('cycles')
          .document(week.cycle.cycleId)
          .collection('weeks')
          .add(week.toJson());
    }
  }

  // day data from snapshot
  Day _dayDataFromSnapshot(DocumentSnapshot snapshot, Week week) {
    return Day.fromJson(snapshot, week);
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

  Future<List<Day>> getDayList(List<Week> weekList) async {
    if (weekList == null) return null;

    List<Day> dayList = [];

    for (Week week in weekList) {
      await userRef
          .collection('programs')
          .document(week.cycle.program.programId)
          .collection('cycles')
          .document(week.cycle.cycleId)
          .collection('weeks')
          .document(week.weekId)
          .collection('days')
          .orderBy('date')
          .getDocuments()
          .then((snapshot) {
        dayList += _dayListFromSnapshot(snapshot, week);
      });
    }
    return dayList;
  }

  // delete a day and subcollections
  Future deleteDay(Day day) async {
    var batch = Firestore.instance.batch();

    DocumentReference dayRef = userRef
        .collection('programs')
        .document(day.week.cycle.program.programId)
        .collection('cycles')
        .document(day.week.cycle.cycleId)
        .collection('weeks')
        .document(day.week.weekId)
        .collection('days')
        .document(day.dayId);

    // delete day Ref ref first so cycle disappears immediately
    // then continue cleaning up subcollections in background
    dayRef.delete();
    day.week.days[DateFormat('EEEE').format(day.date)] = null;
    await updateWeek(day.week);

    QuerySnapshot exCol = await dayRef.collection('exercises').getDocuments();
    for (DocumentSnapshot exDoc in exCol.documents) {
      batch.delete(exDoc.reference);
    }

    // batch.delete(dayRef);
    batch.commit();
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
  Future updateDay(Day day) async {
    bool update = day.dayId != null;
    DocumentReference documentReference;

    if (!update) {
      documentReference = await userRef
          .collection('programs')
          .document(day.week.cycle.program.programId)
          .collection('cycles')
          .document(day.week.cycle.cycleId)
          .collection('weeks')
          .document(day.week.weekId)
          .collection('days')
          .add(day.toJson());

      day.week.days[DateFormat('EEEE').format(day.date)] =
          documentReference.documentID;
      await updateWeek(day.week);

      return documentReference;
    } else {
      return await userRef
          .collection('programs')
          .document(day.week.cycle.program.programId)
          .collection('cycles')
          .document(day.week.cycle.cycleId)
          .collection('weeks')
          .document(day.week.weekId)
          .collection('days')
          .document(day.dayId)
          .setData(day.toJson(), merge: true)
          .whenComplete(() {
        String val = day.week.days.keys
            .firstWhere((k) => day.week.days[k] == day.dayId, orElse: null);
        day.week.days[val] = null;
        day.week.days[DateFormat('EEEE').format(day.date)] = day.dayId;
        updateWeek(day.week);
      });
    }
  }

  // exerciseBase data from snapshot
  ExerciseBase _exerciseBaseDataFromSnapshot(DocumentSnapshot snapshot) {
    return ExerciseBase.fromJson(snapshot);
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

  Future updateExerciseBase(ExerciseBase exerciseBase) async {
    return await userRef
        .collection('exerciseBases')
        .document(exerciseBase.exerciseBaseId)
        .updateData(exerciseBase.toJson(update: true));
  }

  // update a base exercise and exercise
  // TODO: only update base if needed (to save writes to db)
  Future updateExercise(ExerciseBase exerciseBase, Exercise exercise) async {
    bool update = exerciseBase.exerciseBaseId != null;
    DocumentReference documentReference;

    if (!update) {
      documentReference = await userRef
          .collection('exerciseBases')
          .add(exerciseBase.toJson(update: false));

      documentReference = await userRef
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
              update: false, baseId: documentReference.documentID));

      return documentReference;
    } else {
      await userRef
          .collection('exerciseBases')
          .document(exerciseBase.exerciseBaseId)
          .updateData(exerciseBase.toJson(update: update));

      if (exercise.exerciseId != null) {
        await userRef
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
            .updateData(exercise.toJson(update: update));
      } else {
        documentReference = await userRef
            .collection('programs')
            .document(exercise.day.week.cycle.program.programId)
            .collection('cycles')
            .document(exercise.day.week.cycle.cycleId)
            .collection('weeks')
            .document(exercise.day.week.weekId)
            .collection('days')
            .document(exercise.day.dayId)
            .collection('exercises')
            .add(exercise.toJson(update: false));

        return documentReference;
      }
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

  Future<List<ExerciseBase>> getExerciseBaseList() async {
    return userRef
        .collection('exerciseBases')
        .getDocuments()
        .then((snapshot) => _exerciseBaseListFromSnapshot(snapshot));
  }

  Future<List<Exercise>> getExerciseList(List<Day> dayList) async {
    if (dayList == null) return null;

    List<ExerciseBase> exerciseBaseList = await getExerciseBaseList();
    List<Exercise> exerciseList = [];

    for (Day day in dayList) {
      await userRef
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
          .getDocuments()
          .then((snapshot) {
        exerciseList +=
            _exerciseListFromSnapshot(snapshot, day, exerciseBaseList);
      });
    }
    return exerciseList;
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

  /// Delay program from a certain day.
  /// Also works for advancing after a certain day.
  Future delayProgram(Day delayDay, int duration) async {
    return await userRef
        .collection('programs')
        .document(delayDay.week.cycle.program.programId)
        .collection('cycles')
        .document(delayDay.week.cycle.cycleId)
        .collection('weeks')
        .where('startDate',
            isGreaterThanOrEqualTo: (delayDay.date.subtract(Duration(days: 6))))
        .getDocuments()
        .then((value) {
      value.documents.asMap().forEach((index, week) {
        Map<String, dynamic> days = week['days'];
        int index = 0;

        // move each dayId in [week].[days] up/down by duration
        days.forEach((key, value) {
          String oldDay = DateFormat('EEEE')
              .format(week['startDate'].toDate().add(Duration(days: index)));
          String newDay = DateFormat('EEEE').format(
              week['startDate'].toDate().add(Duration(days: duration + index)));

          // don't move days before delayDay (day we want to start delaying)
          if (week['startDate']
              .toDate()
              .add(Duration(days: index))
              .isBefore(delayDay.date.subtract(Duration(days: 1)))) {
            index++;
            return;
          }
          days[newDay] = week['days'][oldDay];
          index++;
        });

        week.reference.updateData({
          'days': days,
          if (week['startDate'].toDate().isAfter(delayDay.date))
            'startDate':
                week['startDate'].toDate().add(Duration(days: duration)),
        }).whenComplete(() {
          week.reference.collection('days').getDocuments().then((value) => {
                value.documents.forEach((day) {
                  if (day['date'].toDate().isAfter(delayDay.date) ||
                      day['date'].toDate().isAtSameMomentAs(delayDay.date))
                    day.reference.updateData({
                      'date': day['date'].toDate().add(Duration(days: duration))
                    });
                })
              });
        });
      });
    });
  }

  void addFeedback(String feedback) async {
    await userRef.collection('feedback').add({'feedback': feedback});
  }
}
