import 'package:Lifter/Services/database.dart';

class User {
  final String uid;
  final String email;
  final String name;

  User({this.uid, this.email, this.name});

  void addBodyweight(DateTime date, double bodyweight) {
    DatabaseService(uid: uid).addBodyweight(date, bodyweight);
  }
}
