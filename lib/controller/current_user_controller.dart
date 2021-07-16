import 'package:flutter/material.dart';

class CurrentUserController extends ChangeNotifier{
  String currentUser = '';

  setCurrentUser(String email) {
    currentUser = email;
    notifyListeners();
  }
}