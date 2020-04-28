import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cycle {
  DocumentReference reference;
  String name;
  DateTime startDate;
  int tmPercent;

  Cycle({
    this.reference,
    @required this.name,
    @required this.startDate,
    @required this.tmPercent,
  });

  Cycle.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['startDate'] != null),
        assert(map['tmPercent'] != null),
        name = map['name'],
        startDate = map['startDate'],
        tmPercent = map['tmPercent'];

  void fromMap(Map<String, dynamic> map) {
    assert(map['name'] != null);
        assert(map['startDate'] != null);
        assert(map['tmPercent'] != null);
        name = map['name'];
        startDate = (map['startDate'] as Timestamp).toDate();
        tmPercent = map['tmPercent'];
  }

  Cycle.fromSnapshot(DocumentSnapshot snapshot) {
    this.reference = snapshot.reference;
    fromMap(snapshot.data);
  }

    Map<String, dynamic> toJson() => {
        'name': name,
        'startDate': startDate,
        'tmPercent': tmPercent,
      };

  @override
  String toString() => "Record<$name>";
}
