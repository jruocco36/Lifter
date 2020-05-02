import 'package:Lifter/models/day.dart';
import 'package:flutter/material.dart';

class DayHome extends StatefulWidget {
  final Day day;

  DayHome({this.day});

  @override
  _DayHomeState createState() => _DayHomeState();
}

class _DayHomeState extends State<DayHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Day ${widget.day.dayName.toString()}'),
    );
  }
}
