import 'package:flutter/material.dart';

class Cycle {
  final String uid;
  final String programId;
  final String cycleId;
  final String name;
  final DateTime startDate;
  final int trainingMaxPercent;

  Cycle({
    @required this.uid,
    @required this.programId,
    @required this.cycleId,
    @required this.name,
    @required this.startDate,
    @required this.trainingMaxPercent,
  });
}