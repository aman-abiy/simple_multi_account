import 'package:flutter/material.dart';
import 'package:multi_account/database/database.dart';
import 'package:multi_account/widgets/drawer.dart';

class Home extends StatefulWidget {
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
             child: FutureBuilder(
               future: DBHelper().getUserData(),
               builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                 print('DDDDDDDDDDDDD ${snapshot.data}');
                  if (snapshot.hasData) {
                    return Column(
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
                    );
                  } 
                  if (snapshot.hasError) {
                    return Text('Error!!!');
                  }  
                  return Text('No user data found');
               }
              ),
           )
         ]
       ),
    );
  }

  showUserdata() async{
    List<Map<String, dynamic>> userData = await DBHelper().getUserData();
  }
}