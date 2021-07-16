import 'package:multi_account/utils/shared_prefs.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  late Database database;

  Future<void> openDB() async {
    String? currUser = await MySharedPreference().getCurrentUser();
    print('currUser $currUser');
    database = await openDatabase(
      join(await getDatabasesPath(), '$currUser.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await _createUserDB(db);
      }
    );      
  }

  

  Future<void> _createUserDB(Database db) async {
    await db.execute("""
      CREATE TABLE `user` (
        `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        `email` TEXT NOT NULL,
        `loggedInAt` TEXT NOT NULL
      );
    """
    );
  }

  Future<void> addUserData(Map<String, dynamic> values) async {
    String? currUser = await MySharedPreference().getCurrentUser();
    print('currUser $currUser');
    database = await openDatabase(
      join(await getDatabasesPath(), '$currUser.db'),
      version: 1,
    ); 
    await database.insert('user', values);
  }

  Future<List<Map<String, dynamic>>> getUserData() async {
    String? currUser = await MySharedPreference().getCurrentUser();
    final String rawQuery = 'SELECT * FROM user';
    print('currUser $currUser');
    database = await openDatabase(
      join(await getDatabasesPath(), '$currUser.db'),
      version: 1,
    ); 
    var result = await database.rawQuery(rawQuery);
    return result;  
  }

}