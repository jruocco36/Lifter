import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './cycleData.dart';

class Program {
  // final int id;
  String name;
  String baseType;
  String progressType;
  Map<int, Cycle> cycles = {};

  // reference to Firestore document for this Program
  DocumentReference reference;
  
  // TODO: pull in cycles from Firebase
  // see subcollections: https://firebase.google.com/docs/firestore/data-model

  Program.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['baseType'] != null),
        assert(map['progressType'] != null),
        name = map['name'],
        baseType = map['baseType'],
        progressType = map['progressType'],
        cycles = map['cycle'];

  Program.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toJson() => {
      'name': name,
      'baseType': baseType,
      'progressType': progressType,
  };

  @override
  String toString() => "Record<$name>";

  Program({
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
    if (cycles != null) {
      cycles.entries.forEach((e) => cycleList.add(e.value));
    }
    return cycleList;
  }
}