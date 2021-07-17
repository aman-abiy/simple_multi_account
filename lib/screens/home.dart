import 'package:flutter/material.dart';
import 'package:multi_account/controller/current_user_controller.dart';
import 'package:multi_account/database/database.dart';
import 'package:multi_account/screens/login.dart';
import 'package:multi_account/widgets/drawer.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  bool refresh = false;
  Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String phoneNo = '';
  String address = 'megenagna';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: AppDrawer(),
      body: Consumer<CurrentUserController>(
        builder: (context, user, child) {
          return ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    showUserdata(user),
                    Divider(height: 50),
                    showInfodata(user)
                  ],
                  
                )
              ),
              Divider(height: 30.0),
              user.currentUser != '' ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: FlatButton(
                  onPressed: () {
                    return _showInfoModal();
                  },
                  color: Colors.blue,
                  child: Text('Add Info')
                ),
              ) : Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: FlatButton(
                  child: Text('Login',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () async =>  {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()))
                  }
                ),
              ),
            ]
          );
        }
    ));
  }

  Widget showUserdata(CurrentUserController user) {
    return FutureBuilder(
      future: DBHelper().getUserData(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        print('DDDDDDDDDDDDD ${snapshot.data}');
        try {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && (snapshot.data != null)) {
              return snapshot.data != [] ? snapshot.data![0]['email'] != null ? Column(
                children: [
                  SizedBox(height: 20),
                  Text('Email: ${snapshot.data![0]['email']}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Divider(thickness: 3),
                  Text('Logged in at: ${snapshot.data![0]['loggedInAt'].split(' ')[0]}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Divider(thickness: 3),
                ]
              ) : Text('Error getting user data') : Text('No data found');
            } 
          }
          if (snapshot.hasError) {
            return Text('Error!!!');
          }  
          return Text('No user data found');
        } catch (e) {
          return Text('No Data');
        }       
      }
    );
  }

  Widget showInfodata(CurrentUserController user) {
    return FutureBuilder(
      future: DBHelper().getInfoData(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        print('DDDDDDDDDDDDD ${snapshot.data}');
        try {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && (snapshot.data != null)) {
              return user.checkForInfo ? user.infoIsAdded ? snapshot.data != [] ? snapshot.data![0]['phoneNo'] != null ? Column(
                children: [
                  SizedBox(height: 20),
                  Text('Phone Number: ${snapshot.data![0]['phoneNo']}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Divider(thickness: 3),
                  Text('Address: ${snapshot.data![0]['address']}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Divider(thickness: 3),
                ]
              ) : Text('Error getting info data') : Text('No data found') : Text('No data found') : Text('No data found');
            } 
          }
          if (snapshot.hasError) {
            return Text('Error!!! ${snapshot.error}');
          }  
          return Text('No info data found');
        } catch(e) {
          return Text('No Data');
        }
      }
    );
  }

  _showInfoModal() {
    return showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (context) {
        return Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  onChanged: (value) {
                    phoneNo = value;
                  },
                  decoration: styleInput('Phone Number')
                ),
              ),
              SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  onChanged: (value) {
                    address = value;
                  },
                  decoration: styleInput('Address')
                ),
              ),
              FlatButton(
                child: Text('Add Info',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).accentColor),
                ),
                color: Colors.white10,
                onPressed: () async =>  {
                  await DBHelper().addInfoData({'phoneNo': phoneNo, 'address': address}),
                  Provider.of<CurrentUserController>(context, listen: false).updateInfoIsAdded(),
                  Navigator.pop(context)
                }
              ),
          ],
        );
      }
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