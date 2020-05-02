import 'package:Lifter/models/cycle.dart';
import 'package:flutter/material.dart';

class Week {
  final Cycle cycle;
  final String weekId;
  final String weekName;
  final DateTime startDate;

  Map<String, dynamic> days = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  Week({
    @required this.cycle,
    @required this.weekId,
    @required this.weekName,
    @required this.startDate,
    this.days
  });
}
