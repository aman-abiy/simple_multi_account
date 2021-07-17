import 'package:flutter/material.dart';

class CurrentUserController extends ChangeNotifier{
  String currentUser = '';
  bool infoIsAdded = false;
  bool checkForInfo = false;

  setCurrentUser(String email) {
    currentUser = email;
    notifyListeners();
  }

  updateInfoIsAdded() {
    infoIsAdded = true;
    notifyListeners();
  }

  checkInfoData() {
    checkForInfo = true;
    notifyListeners();
  }
}