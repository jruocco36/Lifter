import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Week {
  final Cycle cycle;
  final String weekId;
  final String weekName;
  final DateTime startDate;
  final int delayDays;
  DateTime endDate;

  Map<String, dynamic> days = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
    'Sunday': null,
  };

  Week(
      {@required this.cycle,
      @required this.weekId,
      @required this.weekName,
      @required this.startDate,
      @required this.endDate,
      this.delayDays = 0,
      this.days});

  Week.fromJson(DocumentSnapshot snapshot, Cycle cycle)
      : cycle = cycle,
        weekId = snapshot.documentID,
        weekName = snapshot['weekName'],
        startDate = snapshot['startDate'].toDate(),
        endDate =
            snapshot['endDate'] != null ? snapshot['endDate'].toDate() : null,
        days = snapshot['days'],
        delayDays = snapshot['delayDays'];

  Map toJson({bool update = false}) => <String, dynamic>{
        'uid': this.cycle.program.uid,
        'programId': this.cycle.program.programId,
        'cycleId': this.cycle.cycleId,
        'weekName': this.weekName,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'days': this.days,
        'delayDays': this.delayDays,
        if (!update) 'createdDate': DateTime.now()
      };

  Future updateWeek() async {
    DocumentReference result =
        await DatabaseService(uid: cycle.program.uid).updateWeek(this);

    if (this.weekId == null) {
      return Week(
        weekId: result.documentID,
        cycle: this.cycle,
        startDate: this.startDate,
        weekName: this.weekName,
        days: this.days,
        endDate: this.startDate.add(Duration(days: 6)),
      );
    } else {
      return this;
    }
  }
}
