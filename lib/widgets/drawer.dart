import 'package:flutter/material.dart';
import 'package:multi_account/controller/current_user_controller.dart';
import 'package:multi_account/screens/login.dart';
import 'package:multi_account/utils/shared_prefs.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer();

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

  

class _AppDrawerState extends State<AppDrawer> {
  MySharedPreference mySharedPreference = MySharedPreference();
  List<Widget> users = [];

  @override
  void initState() { 
    super.initState();
    getLoggedInUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
       child: ListView(
         children: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10.0),
             child: Text('Accouts',
              style: TextStyle(fontSize: 25),
             ),
           ),
           FutureBuilder(
             initialData: [],
             future: MySharedPreference().getAllUser(),
             builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if(snapshot.connectionState == ConnectionState.active) {
                return CircularProgressIndicator();
              }
              if(snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  print('ALLUSERSss ${snapshot.data}');
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            MySharedPreference().setCurrentUser(snapshot.data![index]);
                            Navigator.pop(context);
                            Provider.of<CurrentUserController>(context, listen: false).setCurrentUser(snapshot.data![index]);
                          },
                          child: ListTile(
                            leading: Icon(Icons.account_box_outlined),
                            title: Text(snapshot.data![index],
                              style: TextStyle(fontSize: 20, color: snapshot.data![index] == Provider.of<CurrentUserController>(context, listen: false).currentUser ? Colors.amber.shade900 : Colors.grey),
                            ),
                          ),
                        );
                      }),
                  );
                }
                if (snapshot.hasError) {
                  return Text('Error!!!');
                }
              }
              return Text('No user data found');
             }
            ),
          //  Column(
          //    children: users
          //  ),
           SizedBox(height: 50.0),
           Row(
             children: [
               FlatButton(
                child: Text('Add account'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                }, 
              ),
              FlatButton(
                child: Text('Logout'),
                onPressed: () async {
                  String currUserBefore = await mySharedPreference.getCurrentUser();
                  mySharedPreference.switchCurrentUser(currUserBefore);
                  // current user is different now (has switched)
                  String currUserAfter = await mySharedPreference.getCurrentUser();
                  Provider.of<CurrentUserController>(context, listen: false).currentUser = currUserAfter;
                  Navigator.pop(context);
                }, 
              )
             ]
           ),
         ]
       ),
    );
  }

  getLoggedInUsers() async {
    List<String> allUsers = await MySharedPreference().getAllUser();
    // allUsers.forEach((element) {
    //   users.add(
    // });
    print('allUsers $allUsers');
  }
}