import 'package:Lifter/models/cycle.dart';
import 'package:flutter/material.dart';

class Week {
  final Cycle cycle;
  final String weekId;
  final String weekName;
  final DateTime startDate;

  Map<String, dynamic> days = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
    'Sunday': null,
  };

  Week({
    @required this.cycle,
    @required this.weekId,
    @required this.weekName,
    @required this.startDate,
    this.days
  });
}
