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
}