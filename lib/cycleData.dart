import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cycle {
  DocumentReference reference;
  String name;
  DateTime startDate;
  int tmPercent;

  Cycle({
    @required this.reference,
    @required this.name,
    @required this.startDate,
    @required this.tmPercent,
  });
}
