import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object from firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? User(uid: user.uid, email: user.email, name: user.displayName)
        : null;
  }

  // auth change user stream
  // whenever there is a change in auth state, return firebase user
  Stream<User> get user {
    // using firebase_user_stream package to listen to user auth or profile changes
    // stand onAuthStateChanged only listens to user sign in/out
    return FirebaseUserReloader.onAuthStateChangedOrReloaded.map(_userFromFirebaseUser);
    // return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // register with email/password
  Future registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = name;
      await user.updateProfile(userUpdateInfo);

      //create a new document for the user we just created
      await DatabaseService(uid: user.uid).updateUser(Timestamp.now());
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return e.code;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return e.code;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateName(String name) async {
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    FirebaseUser user = await _auth.currentUser();
    var result =  await user.updateProfile(userUpdateInfo);
    FirebaseUserReloader.reloadCurrentUser();
    return result;
  }

  Future getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return _userFromFirebaseUser(user);
  }
}
