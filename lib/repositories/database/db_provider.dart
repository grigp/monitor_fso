import 'dart:typed_data';

import 'package:monitor_fso/repositories/database/db_defines.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../defines.dart';

/// Обработчик событий в БД
class HandlerInfo {
  String uid;
  Function func;

  HandlerInfo({
    required this.uid,
    required this.func,
  });
}

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

  List<HandlerInfo> _handlers = [];

  Future _openDB() async {
    if (_dbPath == '') {
      _dbPath = '${await getDatabasesPath()}/data/database.db';
      _db = await openDatabase(_dbPath, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE Tests (uid STRING PRIMARY KEY, dt STRING, patientUid STRING, methodicUid STRING, kfr REAL, freq REAL, data BLOB NOT NULL)');
        await db.execute(
            'CREATE TABLE Patients (uid STRING PRIMARY KEY, fio STRING, born STRING, sex STRING, comment STRING)');
      });
    }
  }

  /// Записывает информацию о тесте в базу данных
  Future addPatient(RecordPatient rec) async {
    await _openDB();
    await _db.insert('Patients', {
      'uid': rec.uid,
      'fio': rec.fio,
      'born': rec.born.toString(),
      'sex': _sexToString(rec.sex),
      'comment': rec.comment,
    });

    /// Известим интересующихся о появлении пациента
    for (int i = 0; i < _handlers.length; ++i) {
      _handlers[i].func(DBEvents.dbeAddPatient, rec.uid);
    }
  }

  /// Возвращает кол-во тестов
  Future<int?> patientsCount() async {
    await _openDB();
    return Sqflite.firstIntValue(
        await _db.rawQuery('SELECT COUNT(*) FROM Patients'));
  }

  /// Возвращает список тестов. Все, кроме данных (BLOB)
  Future<List<RecordPatient>> getListPatients() async {
    await _openDB();
    List<Map> list =
        await _db.rawQuery('SELECT uid, fio, born, sex, comment FROM Patients');
    List<RecordPatient> retval = [];
    for (int i = 0; i < list.length; ++i) {
      retval.add(
        RecordPatient(
          uid: list[i]['uid'],
          fio: list[i]['fio'],
          born: DateTime.parse(list[i]['born']),
          sex: _stringToSex(list[i]['sex']),
          comment: list[i]['comment'],
        ),
      );
    }
    return retval;
  }

  Future deletePatient(String patientUid) async {
    await _openDB();

    /// Удалить запись для этого пациента
    await _db.rawQuery('DELETE FROM Patients WHERE uid = \'$patientUid\'');

    /// Удалить все записи тестов для этого пациента
    await _db.rawQuery('DELETE FROM Tests WHERE patientUid = \'$patientUid\'');

    /// Известим интересующихся об удалении теста
    for (int i = 0; i < _handlers.length; ++i) {
      _handlers[i].func(DBEvents.dbeDeletePatient, patientUid);
    }
  }

  /// Обновляет значение КФР для теста
  Future editPatient(RecordPatient patient) async {
    await _openDB();

    await _db.update(
      'Patients',
      {
        'fio': patient.fio,
        'born': patient.born.toString(),
        'sex': _sexToString(patient.sex),
        'comment': patient.comment,
      },
      where: 'uid = \'${patient.uid}\'',
    );

    // await _db.rawQuery(
    //     'UPDATE Patients SET fio = ${p.fio} born ${p.born.toString()} sex = ${_sexToString(p.sex)} comment = ${p.comment} WHERE uid = \'${p.uid}\'');
    /// Известим интересующихся о появлении пациента
    for (int i = 0; i < _handlers.length; ++i) {
      _handlers[i].func(DBEvents.dbeEditPatient, patient.uid);
    }
  }

  /// Записывает информацию о тесте в базу данных
  Future addTest(RecordTest rec) async {
    var data = await _dataEncode(rec.data);

    await _openDB();
    await _db.insert('Tests', {
      'uid': rec.uid,
      'dt': rec.dt.toString(),
      'patientUid': rec.patientUid,
      'methodicUid': rec.methodicUid,
      'kfr': rec.kfr,
      'freq': rec.freq,
      'data': data,
    });

    /// Известим интересующихся о появлении теста
    for (int i = 0; i < _handlers.length; ++i) {
      _handlers[i].func(DBEvents.dbeAddTest, rec.uid);
    }
  }

  /// Возвращает кол-во тестов
  Future<int?> testsCount() async {
    await _openDB();
    return Sqflite.firstIntValue(
        await _db.rawQuery('SELECT COUNT(*) FROM Tests'));
  }

  /// Возвращает список тестов. Все, кроме данных (BLOB)
  /// Если patientUid задан, не равен '', то возвращается список тестов пациента с указанным uid
  /// Иначе - все тесты
  Future<List<RecordTest>> getListTests(String patientUid) async {
    await _openDB();

    String request =
        'SELECT uid, dt, patientUid, methodicUid, kfr, freq FROM Tests';
    if (patientUid != '') {
      request = '$request WHERE patientUid = \'$patientUid\'';
    }

    List<Map> list = await _db.rawQuery(request);
    List<RecordTest> retval = [];
    for (int i = 0; i < list.length; ++i) {
      retval.add(
        RecordTest(
          uid: list[i]['uid'],
          dt: DateTime.parse(list[i]['dt']),
          patientUid: list[i]['patientUid'],
          methodicUid: list[i]['methodicUid'],
          kfr: list[i]['kfr'],
          freq: list[i]['freq'],
        ),
      );
    }
    return retval;
  }

  /// Возвращает данные теста (BLOB  с сигналами)
  Future<List<DataBlock>> getTestData(String testUid) async {
    await _openDB();
    List<Map<String, dynamic>> testData =
        await _db.rawQuery('SELECT * FROM Tests WHERE uid = \'$testUid\'');
    assert(testData.length == 1, 'Тест не найден. test uid: $testUid');
    Uint8List data = testData[0]['data'];
    var db = _dataDecode(data);
    return db;
  }

  /// Обновляет значение КФР для теста
  Future setKfr(String testUid, double kfr) async {
    await _openDB();
    await _db.rawQuery('UPDATE Tests SET kfr = $kfr WHERE uid = \'$testUid\'');
  }

  Future deleteTest(String testUid) async {
    await _openDB();
    await _db.rawQuery('DELETE FROM Tests WHERE uid = \'$testUid\'');

    /// Известим интересующихся об удалении теста
    for (int i = 0; i < _handlers.length; ++i) {
      _handlers[i].func(DBEvents.dbeDeleteTest, testUid);
    }
  }

  /// Добавляет обработчик событий.
  /// Возвращает uid. присвоенный обработчику
  String addHandler(Function handler) {
    var uid = const Uuid().v1();
    var hi = HandlerInfo(
      uid: uid,
      func: handler,
    );
    _handlers.add(hi);
    return uid;
  }

  /// Удаляет обработчик событий
  void removeHandler(String uid) {
    int idx = -1;
    for (int i = 0; i < _handlers.length; ++i) {
      if (_handlers[i].uid == uid) {
        idx = i;
        break;
      }
    }
    if (idx > -1) {
      _handlers.removeAt(idx);
    }
  }

  /// Добавляет в список list по байтам значение value, начиная с индекса idx
  void _addValueToIntList(List<int> list, int idx, double value) {
    ByteData bd = ByteData(8);
    bd.setFloat64(0, value);
    var vBt = bd.buffer.asUint8List();
    for (int j = 0; j < 8; ++j) {
      list[idx + j] = vBt[j];
    }
  }

  /// Переводит данные теста из удобного формата для отображения в
  /// формат для сохранения в базе данных (BLOB)
  Future<Uint8List> _dataEncode(List<DataBlock> data) async {
    List<int> li = List.filled(data.length * 48, 0);

    for (int i = 0; i < data.length; ++i) {
      _addValueToIntList(li, i * 48, data[i].ax);
      _addValueToIntList(li, i * 48 + 8, data[i].ay);
      _addValueToIntList(li, i * 48 + 16, data[i].az);
      _addValueToIntList(li, i * 48 + 24, data[i].gx);
      _addValueToIntList(li, i * 48 + 32, data[i].gy);
      _addValueToIntList(li, i * 48 + 40, data[i].gz);
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

    int n = 0;

    for (int i = 0; i < data.length; i += 8) {
      if (n % 6 == 0) {
        ax = bdR.getFloat64(i);
      } else if (n % 6 == 1) {
        ay = bdR.getFloat64(i);
      } else if (n % 6 == 2) {
        az = bdR.getFloat64(i);
      } else if (n % 6 == 3) {
        gx = bdR.getFloat64(i);
      } else if (n % 6 == 4) {
        gy = bdR.getFloat64(i);
      } else if (n % 6 == 5) {
        gz = bdR.getFloat64(i);
        var block = DataBlock(ax: ax, ay: ay, az: az, gx: gx, gy: gy, gz: gz);
        retval.add(block);
      }
      ++n;
    }
    return retval;
  }

  String _sexToString(Sex sex) {
    if (sex == Sex.male) {
      return 'male';
    } else {
      return 'female';
    }
  }

  Sex _stringToSex(String ssex) {
    if (ssex == 'male') {
      return Sex.male;
    } else {
      return Sex.female;
    }
  }
}

enum DBEvents { dbeAddTest, dbeDeleteTest, dbeAddPatient, dbeEditPatient, dbeDeletePatient }
