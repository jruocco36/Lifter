import 'package:Lifter/models/week.dart';
import 'package:flutter/material.dart';

class Day {
  final String dayId;
  final Week week;
  final DateTime date;
  final String dayName;
  double bodyWeight;

  Day({
    @required this.dayId,
    @required this.week,
    @required this.date,
    @required this.dayName,
    this.bodyWeight,
  });
}
