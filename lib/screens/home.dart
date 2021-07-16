import 'package:flutter/material.dart';
import 'package:multi_account/controller/current_user_controller.dart';
import 'package:multi_account/database/database.dart';
import 'package:multi_account/widgets/drawer.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  bool refresh = false;
  Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: AppDrawer(),
       body: ListView(
         children: [
           Center(
             child: Consumer<CurrentUserController>(
              builder: (context, user, child) {
                return showUserdata(user);
              })
           )
         ]
       ),
    );
  }

  Widget showUserdata(CurrentUserController user) {
    return FutureBuilder(
      future: DBHelper().getUserData(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        print('DDDDDDDDDDDDD ${snapshot.data}');
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && (snapshot.data != null)) {
            return snapshot.data != [] ? snapshot.data![0]['email'] == user.currentUser ? Column(
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
      }
    );
  }
}