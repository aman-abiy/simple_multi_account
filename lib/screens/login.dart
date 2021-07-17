import 'package:flutter/material.dart';
import 'package:multi_account/controller/current_user_controller.dart';
import 'package:multi_account/database/database.dart';
import 'package:multi_account/model/user.dart';
import 'package:multi_account/utils/shared_prefs.dart';
import 'package:multi_account/widgets/drawer.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  MySharedPreference mySharedPreference = MySharedPreference();
  String email = '';
  User user = User('', '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      drawer: AppDrawer(),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: styleInput('Email')
                ),
              ),
              SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  decoration: styleInput('Password')
                ),
              ),
              FlatButton(
                child: Text('Login',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).accentColor),
                ),
                color: Colors.white10,
                onPressed: () async =>  {
                  mySharedPreference.setCurrentUser(email),
                  mySharedPreference.addUserToList(email),
                  user = User(
                    email,
                    DateTime.now().toString()
                  ),
                  await DBHelper().openDB(),
                  await DBHelper().addUserData(user.toMap()),
                  Provider.of<CurrentUserController>(context, listen: false).currentUser = email,
                  Provider.of<CurrentUserController>(context, listen: false).checkForInfo = true,
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()))
                }
              ),
            ]
          )
        ]
      )
    );
  }

  InputDecoration styleInput(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
      contentPadding: Theme.of(context).inputDecorationTheme.contentPadding,
      filled: true,
      fillColor: Theme.of(context).inputDecorationTheme.fillColor,
      enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
      focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder
    );
  }
}