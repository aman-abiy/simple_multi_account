import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference {
  // Future<SharedPreferences> sharedPreference = SharedPreferences.getInstance();
  List<String> usersList = [];

  setCurrentUser(String email) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('curr_user', email);
  }

  Future<String> getCurrentUser() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString('curr_user') ?? '';
  }

  Future<void> addUserToList(String email) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    usersList = sharedPref.getStringList('users_list') ?? [];
    usersList.add(email);
    sharedPref.setStringList('users_list', usersList);
  }

  Future<bool> checkIfUserInUsersList(String email) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    usersList = sharedPref.getStringList('users_list') ?? [];
    return usersList.contains(email) ? true : false;
  }

  Future<List<String>> getAllUser() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getStringList('users_list') ?? [];
  }
}