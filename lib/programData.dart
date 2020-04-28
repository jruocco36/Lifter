import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './cycleData.dart';

class Program {
  DocumentReference
      reference; // reference to Firestore document for this Program
  String name;
  String baseType;
  String progressType;
  Map<DocumentReference, Cycle> cycles = {};

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
        Cycle cycle = Cycle.fromSnapshot(doc);
        cycles[doc.reference] = cycle;
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

  void addCycle(String name, DateTime startDate, int tmPercent) {
    Cycle cycle = Cycle(name: name, startDate: startDate, tmPercent: tmPercent);
    reference.collection('cycle').add(cycle.toJson());
  }

  void updateCycle(Cycle cycle) async {
    await reference.collection('cycle').document(cycle.reference.documentID).updateData(cycle.toJson());
  }

  void deleteCycle(DocumentReference ref) async {
    await reference.collection('cycle').document(ref.documentID).delete();
  }

  List<Cycle> getCycles() {
    List<Cycle> cycleList = [];
    if (cycles != null) {
      cycles.entries.forEach((e) => cycleList.add(e.value));
    }
    return cycleList;
  }
}
