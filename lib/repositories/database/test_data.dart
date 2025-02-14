import 'package:monitor_fso/repositories/database/db_defines.dart';
import 'package:monitor_fso/repositories/defines.dart';
import 'package:uuid/uuid.dart';

/// Класс, содержащий данные теста
class TestData {
  late String _uid;
  late DateTime _dt;
  late double _kfr;
  late double _freq;
  List<DataBlock> _data = [];

  late TestInfoMode _mode;

  // bool _saved = false;

  TestData();

  /// Конструктор для использования при записи сигнала
  factory TestData.fromRecord(double freq) {
    var obj = TestData();
    obj._dt = DateTime.now();
    obj._uid = const Uuid().v1();
    obj._kfr = 0;
    obj._freq = freq;
    obj._data.clear();
    obj._mode = TestInfoMode.timRecording;

    return obj;
  }

  /// Конструктор для использования при чтении данных из базы данных
  factory TestData.fromDb(RecordTest rt) {
    var obj = TestData();
    obj._uid = rt.uid;
    obj._dt = rt.dt;
    obj._kfr = rt.kfr;
    obj._freq = rt.freq;
    obj._data = rt.data;
    obj._mode = TestInfoMode.timWorking;

    /// Вызвать расчет показателей для их перерасчета
    /// Надо еще и сохранить новые значения

    return obj;
  }

  /// Добавляет блок данных в режиме записи
  void addValue(DataBlock db) {
//    if (_mode == TestInfoMode.timRecording && !_saved) {
    if (_mode == TestInfoMode.timRecording) {
      _data.add(db);
    }
  }

  /// Очищает данные
  void clear() {
    _data.clear();
  }

  /// Завершает запись в режиме записи
  void finish() {
    if (_mode == TestInfoMode.timRecording) {
      /// Обновляем дату и время проведения моментом окончания теста
      _dt = DateTime.now();
      /// Вызвать расчет показателей
    }
  }

  // /// Сохраняет данные в БД в режиме записи Сохранять надо снаружи
  // void save() {
  //   if (_mode == TestInfoMode.timRecording && ! _saved) {
  //     var rc = RecordTest(uid: uid, dt: dt, methodicUid: uidMethodicRec, kfr: kfr);
  //     rc.data = data;
  //     GetIt.I<DbProvider>().addTest(rc);
  //     _saved = true;
  //   }
  // }

  /// Возвращает uid теста
  String uid() {
    return _uid;
  }

  /// Возвращает время проведения теста
  DateTime dateTime() {
    return _dt;
  }

  /// Возвращает КФР теста
  double kfr() {
    return _kfr;
  }

  /// Возвращает частоту дискретизации сигналов теста
  double freq() {
    return _freq;
  }

  /// Возвращает кол-во записей данных в тесте
  int dataSize() {
    return _data.length;
  }

  /// Возвращает запсиь данных теста
  DataBlock data(int i) {
    assert(i >= 0 && i < _data.length);
    return _data[i];
  }
}

/// Режимы работы: запись и обработка
enum TestInfoMode { timRecording, timWorking }
