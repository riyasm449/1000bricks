import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '/models/user.dart';

class UserProvider extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel _user;
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  UserModel get user => _user;

  Future<void> getUserDetails(String userId) async {
    _isLoading = true;
    try {
      print(userId);
      DocumentSnapshot userData = await _firestore.collection('users').doc(userId).get();
      _user = UserModel.fromJson(userData.data());
      print(userData.data());
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
    }
  }
}
