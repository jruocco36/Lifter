import 'package:cloud_firestore/cloud_firestore.dart';

import './programData.dart';

class DataRepository {
  // reference to collection
  final CollectionReference collection = Firestore.instance.collection('program');
  // get snapshots from collection
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  //Add new program
  Future<DocumentReference> addProgram(Program program) {
    return collection.add(program.toJson());
  }
  // Update program
  updateProgram(Program program) async {
    await collection.document(program.reference.documentID).updateData(program.toJson());
  }
  // Delete program
  deleteProgram(DocumentReference reference) async {
    await collection.document(reference.documentID).delete();
  }
}