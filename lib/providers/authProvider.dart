import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Status { Uninitialized, Authenticated, Unauthenticated, Authenticating }

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  final firestore = FirebaseFirestore.instance;

  //getters
  FirebaseAuth get auth => _auth;
  FirebaseUser get user => _user;
  Status get status => _status;

  void changeStatus(Status value) {
    _status = value;
    notifyListeners();
  }

  Future<void> signIn({@required String email, @required String password}) async {
    _status = Status.Authenticating;
    notifyListeners();
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    _status = Status.Authenticated;
    notifyListeners();
  }

  Future<void> _onStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Uninitialized;
    } else {
      // _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
