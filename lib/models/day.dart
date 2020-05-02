import 'package:Lifter/models/cycle.dart';
import 'package:flutter/material.dart';

class Day {
  final String dayId;
  final DateTime date;
  final Cycle cycle;
  final String dayName;
  double bodyWeight;

  Day({
    @required this.dayId,
    @required this.date,
    @required this.cycle,
    @required this.dayName,
    this.bodyWeight,
  });
}
