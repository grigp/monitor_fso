
import 'package:sqflite/sqflite.dart';

class DbProvider {

  DbProvider() {
    _openDB();
  }

  late String _dbPath;
  late Database _db;

  void _openDB() async {
    _dbPath = '${await getDatabasesPath()}/data/tests.db';
    print('----------------------------');
    print(_dbPath);
    print('----------------------------');
//    _db = await openDatabase(_dbPath);
  }

  int getValue() {
    return 25;
  }

}