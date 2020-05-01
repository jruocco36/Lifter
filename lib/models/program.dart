import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Program {
  final String uid;
  final String programId;
  final String name;
  final String programType; // cycle based or day based
  final String progressType; // 1RM based or Training Max based
  final Timestamp createdDate;

  Program(
      {@required this.uid,
      @required this.programId,
      @required this.name,
      @required this.programType,
      @required this.progressType,
      @required this.createdDate});
}
