import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './cycleData.dart';

class Program {
  // final int id;
  String name;
  String baseType;
  String progressType;
  Map<DocumentReference, Cycle> cycles = {};

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
        progressType = map['progressType'];

  void fromMap(Map<String, dynamic> map) {
    assert(map['name'] != null);
    assert(map['baseType'] != null);
    assert(map['progressType'] != null);
    name = map['name'];
    baseType = map['baseType'];
    progressType = map['progressType'];
  }

  Program.fromSnapshot(DocumentSnapshot snapshot) {
    this.reference = snapshot.reference;
    reference.collection('cycle').getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((DocumentSnapshot doc) {
        newCycle(
            doc.reference,
            doc['name'],
            (doc['startDate'] as Timestamp).toDate(),
            doc['tmPercent']);
      });
    });
    fromMap(snapshot.data);
  }
  // : this.fromMap(snapshot.data, reference: snapshot.reference);

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

  // TODO: redo newCycle with Firebase

  void newCycle(DocumentReference reference, String name, DateTime startDate,
      int tmPercent) {
    if (cycles == null) cycles = {};
    cycles[reference] = new Cycle(
      reference: reference,
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
