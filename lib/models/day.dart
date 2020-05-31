import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/week.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Day {
  final String dayId;
  final Week week;
  final DateTime date;
  final int delayDays;
  final String dayName;

  Day({
    @required this.dayId,
    @required this.week,
    @required this.date,
    this.delayDays,
    @required this.dayName,
  });

  Day.fromJson(DocumentSnapshot snapshot, Week week)
      : date = snapshot['date'].toDate(),
        delayDays = snapshot['delayDays'],
        week = week,
        dayId = snapshot.documentID,
        dayName = snapshot['dayName'];

  Map toJson({bool update = false}) => <String, dynamic>{
        'uid': week.cycle.program.uid,
        'programId': week.cycle.program.programId,
        'cycleId': week.cycle.cycleId,
        'weekId': week.weekId,
        'dayName': dayName,
        'date': date,
        'delayDays': delayDays,
      };

  Future updateDay() async {
    DocumentReference result =
        await DatabaseService(uid: week.cycle.program.uid).updateDay(this);

    if (this.dayId == null) {
      return Day(
        dayId: result.documentID,
        date: this.date,
        delayDays: this.delayDays,
        dayName: this.dayName,
        week: this.week,
      );
    } else {
      return this;
    }
  }
}
