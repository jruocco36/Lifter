import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/program.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cycle {
  final Program program;
  final String cycleId;
  final String name;
  final DateTime startDate;
  final double trainingMaxPercent;

  Cycle({
    @required this.program,
    @required this.cycleId,
    @required this.name,
    @required this.startDate,
    @required this.trainingMaxPercent,
  });

  Cycle.fromJson(DocumentSnapshot snapshot, Program program)
      : program = program,
        cycleId = snapshot.documentID,
        name = snapshot['cycleName'],
        startDate = snapshot['startDate'].toDate(),
        trainingMaxPercent = snapshot['trainingMaxPercent'].toDouble();

  Map toJson({bool update = false}) => <String, dynamic>{
        'uid': this.program.uid,
        'programId': this.program.programId,
        'cycleName': this.name,
        'startDate': Timestamp.fromDate(startDate),
        'trainingMaxPercent': trainingMaxPercent,
        if (!update) 'createdDate': Timestamp.now(),
      };

  // TODO: refractor all updates to be like this
  Future updateCycle() async {
    await DatabaseService(uid: program.uid).updateCycle(this);
  }
}
