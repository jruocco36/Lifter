import 'package:flutter/material.dart';

import './cycleData.dart';

class Program {
  final int id;
  String name;
  String baseType;
  String progressType;
  Map<int, Cycle> cycles = {};

  Program({
    @required this.id,
    @required this.name,
    @required this.baseType,
    @required this.progressType,
    this.cycles,
  });

  void newCycle(int id, String name, DateTime startDate, int tmPercent) {
    if (cycles == null) cycles = {};
    cycles[id] = new Cycle(
      id: id,
      name: name,
      startDate: startDate,
      tmPercent: tmPercent,
    );
  }

  List<Cycle> getCycles() {
    List<Cycle> cycleList = [];
    if(cycles != null) {
      cycles.entries.forEach((e) => cycleList.add(e.value));
    }
    return cycleList;
  }
}
