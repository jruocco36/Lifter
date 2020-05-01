import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/program.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // current user's id
  final String uid;
  final DocumentReference userRef;
  DatabaseService({this.uid})
      : userRef = Firestore.instance.collection('users').document(uid);

  // update this user data for this user
  Future updateUser(Timestamp createDate) async {
    return await userRef.setData({
      'createdDate': createDate,
    });
  }

  // update a program for this user
  Future updateProgram(String programId, String programName, String programType,
      String progressType, Timestamp createdDate) async {
    return await userRef
        .collection('programs')
        .document(programId ?? null)
        .setData({
      'programName': programName,
      'programType': programType,
      'progressType': progressType,
      'createdDate': createdDate,
    });
  }

  // delete a program for this user
  Future deleteProgram(String programId) async {
    return await userRef.collection('programs').document(programId).delete();
  }

  // program list from snapshot
  List<Program> _programListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Program(
        uid: uid,
        programId: doc.documentID,
        name: doc['programName'],
        programType: doc['programType'],
        progressType: doc['progressType'],
        createdDate: doc['createdDate'],
      );
    }).toList();
  }

  // get programs stream
  Stream<List<Program>> get programs {
    return userRef
        .collection('programs')
        .orderBy('createdDate')
        .snapshots()
        .map(_programListFromSnapshot);
  }

  // program data from snapshot
  Program _programDataFromSnapshot(DocumentSnapshot snapshot) {
    return Program(
      uid: uid,
      programId: snapshot.documentID,
      name: snapshot.data['programName'],
      programType: snapshot.data['programType'],
      progressType: snapshot.data['progressType'],
      createdDate: snapshot.data['createdDate'],
    );
  }

  // get program data stream for specific program id
  Stream<Program> getProgramData(String programId) {
    return userRef
        .collection('programs')
        .document(programId)
        .snapshots()
        .map(_programDataFromSnapshot);
  }

  // program's cycle data from snapshot
  List<Cycle> _cycleListFromSnapshot(QuerySnapshot snapshot, String programId) {
    return snapshot.documents.map((doc) {
      return Cycle(
        uid: uid,
        programId: programId,
        cycleId: doc.documentID,
        name: doc['cycleName'],
        startDate: doc['startDate'].toDate(),
        trainingMaxPercent: doc['trainingMaxPercent'],
      );
    }).toList();
  }

  // get stream for program's cycles
  Stream<List<Cycle>> getCycles(String programId) {
    return userRef
        .collection('programs')
        .document(programId)
        .collection('cycles')
        .snapshots()
        .map((snapshot) => _cycleListFromSnapshot(snapshot, programId));
  }

  // program data from snapshot
  Cycle _cycleDataFromSnapshot(DocumentSnapshot snapshot, String programId) {
    return Cycle(
      uid: uid,
      programId: programId,
      cycleId: snapshot.documentID,
      name: snapshot['cycleName'],
      startDate: snapshot['startDate'].toDate(),
      trainingMaxPercent: snapshot['trainingMaxPercent'],
    );
  }

  // get cycle data stream for specific program id and cycle id
  Stream<Cycle> getCycleData(String programId, String cycleId) {
    return userRef
        .collection('programs')
        .document(programId)
        .collection('cycles')
        .document(cycleId)
        .snapshots()
        .map((snapshot) => _cycleDataFromSnapshot(snapshot, programId));
  }

  // update a cycle
  Future updateCycle(String programId, String cycleId, String cycleName,
      DateTime startDate, int trainingMaxPercent) async {
    return await userRef
        .collection('programs')
        .document(programId)
        .collection('cycles')
        .document(cycleId)
        .setData({
      'uid': uid,
      'programId': programId,
      'cycleName': cycleName,
      'startDate': Timestamp.fromDate(startDate),
      'trainingMaxPercent': trainingMaxPercent,
    });
  }

  // delete a cycle
  Future deleteCycle(String programId, String cycleId) async {
    return await userRef
        .collection('programs')
        .document(programId)
        .collection('cycles')
        .document(cycleId)
        .delete();
  }
}
