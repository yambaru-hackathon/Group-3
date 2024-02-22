
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ProfileModel extends ChangeNotifier {
 
  bool isLoading = false;
  String? email;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void fetchUser(){
    final user = FirebaseAuth.instance.currentUser;
  this.email = user?.email;
  notifyListeners();

  }
}