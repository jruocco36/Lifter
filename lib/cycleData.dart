import 'package:flutter/material.dart';

class Cycle {
  int id;
  String name;
  DateTime startDate;
  int tmPercent;

  Cycle({
    @required this.id,
    @required this.name,
    @required this.startDate,
    @required this.tmPercent,
  });
}
