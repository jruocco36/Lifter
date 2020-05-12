import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/program.dart';
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

  // TODO: refractor all updates to be like this
  void updateCycle() async {
    await DatabaseService(uid: program.uid).updateCycle(this.program.programId,
        this.cycleId, this.name, this.startDate, this.trainingMaxPercent);
  }
}
