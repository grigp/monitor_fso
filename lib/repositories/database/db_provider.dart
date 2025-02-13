import 'dart:typed_data';

import 'package:monitor_fso/repositories/database/db_defines.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  DbProvider() {
    double d = 123.45;
    ByteData bd = ByteData(8);
    bd.setFloat64(0, d);

    double d1 = 567.98;
    ByteData bd1 = ByteData(8);
    bd1.setFloat64(0, d1);

    double d2 = 736.096;
    ByteData bd2 = ByteData(8);
    bd2.setFloat64(0, d2);

    List<int> li = [];
    li = bd.buffer.asUint8List() + bd1.buffer.asUint8List() + bd2.buffer.asUint8List();
    final list = Uint8List.fromList(li);

    print('------- $list');

    final bdR = ByteData.sublistView(list);
    print('------- values count: ${list.length ~/ 8}');
    for (int i = 0; i < list.length; i+=8) {
      double v = bdR.getFloat64(i);
      print('--- ${i~/8}: $v');
    }
  }

  String _dbPath = '';
  late Database _db;

  Future _openDB() async {
    if (_dbPath == '') {
      _dbPath = '${await getDatabasesPath()}/data/database.db';
      _db = await openDatabase(_dbPath, version: 1,
          onCreate: (Database db, int version) async {
            await _db.execute(
                'CREATE TABLE Tests (uid STRING PRIMARY KEY, dt STRING, methodicUid STRING, data BLOB NOT NULL)');
          });
    }
  }

  void addTest(RecordTest rec) async {
    await _openDB();
    await _db.insert('Tests', {
      'uid': rec.uid,
      'dt': rec.dt.toString(),
      'methodicUid': rec.methodicUid,
      'data': rec.data
    });
    // await _db.transaction((txn) async {
    //   await txn.rawInsert(
    //       'INSERT INTO Tests(uid, dt, methodicUid) VALUES("${rec.uid}", "${rec.dt.toString()}", "${rec.methodicUid}")');
    //   ///TODO: добавить данные из rec.data (BLOB)
    //
    // });
  }

  Future<int?> testsCount() async {
    await _openDB();
    return Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM Tests'));
  }

  Future<List<RecordTest>> getListTests() async {
    await _openDB();
    List<Map> list =
        await _db.rawQuery('SELECT uid, dt, methodicUid FROM Tests');
    List<RecordTest> retval = [];
    for (int i = 0; i < list.length; ++i) {
      retval.add(
        RecordTest(
            uid: list[i]['uid'],
            dt: DateTime.parse(list[i]['dt']),
            methodicUid: list[i]['methodicUid']),
      );
    }
    return retval;
  }

  Future<List<Map<String, dynamic>>> getTestData(String testUid) async {
    await _openDB();
    return await _db.query('Tests', where: "uid LIKE '%$testUid%'");
  }

  String getValue() {
    final dt = DateTime.parse('2012-07-12 12:25'); //DateTime.now();
    final sdt = dt.toString();
    final dt1 = DateTime.parse(sdt);

    return '${dt.toString()}  -> ($sdt) ->  ${dt1.toString()}';
  }
}
