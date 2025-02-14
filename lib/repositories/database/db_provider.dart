import 'dart:typed_data';

import 'package:monitor_fso/repositories/database/db_defines.dart';
import 'package:sqflite/sqflite.dart';

import '../defines.dart';

class DbProvider {
  DbProvider() {
    // double d = 123.45;
    // ByteData bd = ByteData(8);
    // bd.setFloat64(0, d);
    //
    // double d1 = 567.98;
    // ByteData bd1 = ByteData(8);
    // bd1.setFloat64(0, d1);
    //
    // double d2 = 736.096;
    // ByteData bd2 = ByteData(8);
    // bd2.setFloat64(0, d2);
    //
    // List<int> li = [];
    // li = bd.buffer.asUint8List() +
    //     bd1.buffer.asUint8List() +
    //     bd2.buffer.asUint8List();
    // final list = Uint8List.fromList(li);
    //
    // print('------- $list');
    //
    // final bdR = ByteData.sublistView(list);
    // print('------- values count: ${list.length ~/ 8}');
    // for (int i = 0; i < list.length; i += 8) {
    //   double v = bdR.getFloat64(i);
    //   print('--- ${i ~/ 8}: $v');
    // }
  }

  String _dbPath = '';
  late Database _db;

  Future _openDB() async {
    if (_dbPath == '') {
      _dbPath = '${await getDatabasesPath()}/data/database.db';
      _db = await openDatabase(_dbPath, version: 1,
          onCreate: (Database db, int version) async {
        await _db.execute(
            'CREATE TABLE Tests (uid STRING PRIMARY KEY, dt STRING, methodicUid STRING, kfr REAL, data BLOB NOT NULL)');
      });
    }
  }

  /// Записывает информацию о тесте в базу данных
  void addTest(RecordTest rec) async {
    await _openDB();
    await _db.insert('Tests', {
      'uid': rec.uid,
      'dt': rec.dt.toString(),
      'methodicUid': rec.methodicUid,
      'kfr': rec.kfr,
      'data': _dataEncode(rec.data),
    });
    // await _db.transaction((txn) async {
    //   await txn.rawInsert(
    //       'INSERT INTO Tests(uid, dt, methodicUid) VALUES("${rec.uid}", "${rec.dt.toString()}", "${rec.methodicUid}")');
    //   ///TODO: добавить данные из rec.data (BLOB)
    //
    // });
  }

  /// Возвращает кол-во тестов
  Future<int?> testsCount() async {
    await _openDB();
    return Sqflite.firstIntValue(
        await _db.rawQuery('SELECT COUNT(*) FROM Tests'));
  }

  /// Возвращает список тестов. Все, кроме данных (BLOB)
  Future<List<RecordTest>> getListTests() async {
    await _openDB();
    List<Map> list =
        await _db.rawQuery('SELECT uid, dt, methodicUid, kfr FROM Tests');
    List<RecordTest> retval = [];
    for (int i = 0; i < list.length; ++i) {
      retval.add(
        RecordTest(
            uid: list[i]['uid'],
            dt: DateTime.parse(list[i]['dt']),
            methodicUid: list[i]['methodicUid'],
            kfr: list[i]['kfr']),
      );
    }
    return retval;
  }

  /// Возвращает данные теста (BLOB  с сигналами)
  Future<List<DataBlock>> getTestData(String testUid) async {
    await _openDB();
    List<Map<String, dynamic>> testData =
        await _db.query('Tests', where: "uid LIKE '%$testUid%'");
    assert(testData.length != 1, 'Тест не найден. test uid: $testUid');
    Uint8List data = testData[0]['data'];
    return _dataDecode(data);
  }

  /// Обновляет значение КФР для теста
  Future setKfr(String testUid, double kfr) async {
    await _openDB();
    await _db.rawQuery('UPDATE Tests SET kfr = $kfr WHERE uid = $testUid');
  }

  String getValue() {
    final dt = DateTime.parse('2012-07-12 12:25'); //DateTime.now();
    final sdt = dt.toString();
    final dt1 = DateTime.parse(sdt);

    return '${dt.toString()}  -> ($sdt) ->  ${dt1.toString()}';
  }

  /// Переводит данные теста из удобного формата для отображения в
  /// формат для сохранения в базе данных (BLOB)
  Uint8List _dataEncode(List<DataBlock> data) {
    List<int> li = [];
    for (int i = 0; i < data.length; ++i) {
      ByteData bdAx = ByteData(8);
      bdAx.setFloat64(0, data[i].ax);

      ByteData bdAy = ByteData(8);
      bdAy.setFloat64(0, data[i].ay);

      ByteData bdAz = ByteData(8);
      bdAz.setFloat64(0, data[i].az);

      ByteData bdGx = ByteData(8);
      bdGx.setFloat64(0, data[i].gx);

      ByteData bdGy = ByteData(8);
      bdGy.setFloat64(0, data[i].gy);

      ByteData bdGz = ByteData(8);
      bdGz.setFloat64(0, data[i].gz);

      li = li +
          bdAx.buffer.asUint8List() +
          bdAy.buffer.asUint8List() +
          bdAz.buffer.asUint8List() +
          bdGx.buffer.asUint8List() +
          bdGy.buffer.asUint8List() +
          bdGz.buffer.asUint8List();
    }
    return Uint8List.fromList(li);
  }

  /// Переводит данные теста из формата для сохранения в базе данных (BLOB) в
  /// удобный формат для отображения
  List<DataBlock> _dataDecode(Uint8List data) {
    List<DataBlock> retval = [];
    final bdR = ByteData.sublistView(data);
    double ax = 0;
    double ay = 0;
    double az = 0;
    double gx = 0;
    double gy = 0;
    double gz = 0;

    for (int i = 0; i < data.length; i += 8) {
      if (i % 6 == 0) {
        ax = bdR.getFloat64(i);
      } else if (i % 6 == 1) {
        ay = bdR.getFloat64(i);
      } else if (i % 6 == 2) {
        az = bdR.getFloat64(i);
      } else if (i % 6 == 3) {
        gx = bdR.getFloat64(i);
      } else if (i % 6 == 4) {
        gy = bdR.getFloat64(i);
      } else if (i % 6 == 5) {
        gz = bdR.getFloat64(i);
        var block = DataBlock(ax: ax, ay: ay, az: az, gx: gx, gy: gy, gz: gz);
        retval.add(block);
      }
    }
    return retval;
  }
}
