import 'package:multi_account/utils/shared_prefs.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  late Database database;

  Future<void> openDB() async {
    String currUser = await MySharedPreference().getCurrentUser();
    database = await openDatabase(
      join(await getDatabasesPath(), '$currUser.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await _createUserTable(db);
        await _createInfoTable(db);
      }
    );      
  }

  Future<Database> _getDatabase() async {
    String currUser = await MySharedPreference().getCurrentUser();
    return await openDatabase(
      join(await getDatabasesPath(), '$currUser.db'),
    );
  } 

  Future<void> _createUserTable(Database db) async {
    await db.execute("""
      CREATE TABLE `user` (
        `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        `email` TEXT NOT NULL,
        `loggedInAt` TEXT NOT NULL
      );
    """
    );
  }

  Future<void> _createInfoTable(Database db) async {
    await db.execute("""
      CREATE TABLE `Info` (
        `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        `phoneNo` TEXT NOT NULL,
        `address` TEXT NOT NULL
      );
    """
    );
  }

  Future<void> addUserData(Map<String, dynamic> values) async {
    database = await _getDatabase();
    await database.insert('user', values);
  }

  Future<List<Map<String, dynamic>>> getUserData() async {
    final String rawQuery = 'SELECT * FROM user';
    database = await _getDatabase();
    var result = await database.rawQuery(rawQuery);

    if (result != []) {
      return result;  
    }
    return [{'email': '-', 'loggedInAt': '-'}];  
  }

  Future<void> addInfoData(Map<String, dynamic> values) async {
    database = await _getDatabase();
    await database.insert('info', values);
  }

  Future<List<Map<String, dynamic>>> getInfoData() async {
    final String rawQuery = 'SELECT * FROM info';
    database = await _getDatabase();
    var result = await database.rawQuery(rawQuery);

    if (result != []) {
      return result;  
    }
    return [{'phoneNo': '-', 'address': '-'}];  
  }

}