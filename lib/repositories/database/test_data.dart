import 'package:monitor_fso/calculators/kfr_calculator.dart';
import 'package:monitor_fso/repositories/database/db_defines.dart';
import 'package:monitor_fso/repositories/defines.dart';
import 'package:uuid/uuid.dart';

/// Класс, содержащий данные теста
class TestData {
  late String _uid;
  late DateTime _dt;
  late double _freq;
  List<DataBlock> _data = [];

  late TestInfoMode _mode;

  late bool _calculated = false;
  late KfrCalculator _calculator;
  bool _isSaved = false;

  // bool _saved = false;

  TestData();

  /// Конструктор для использования при записи сигнала
  factory TestData.fromRecord(double freq) {
    var obj = TestData();
    obj._dt = DateTime.now();
    obj._uid = const Uuid().v1();
    obj._freq = freq;
    obj._data.clear();
    obj._mode = TestInfoMode.timRecording;
    obj._isSaved = false;

    return obj;
  }

  /// Конструктор для использования при чтении данных из базы данных
  factory TestData.fromDb(RecordTest rt) {
    var obj = TestData();
    obj._uid = rt.uid;
    obj._dt = rt.dt;
    obj._freq = rt.freq;
    obj._data = rt.data;
    obj._mode = TestInfoMode.timWorking;
    obj._isSaved = true;

    /// Вызвать расчет показателей для их перерасчета
    /// Надо еще и сохранить новые значения
    obj._calculator = KfrCalculator(rt.data);
    obj._calculated = true;

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
  Future finish() async {
    if (_mode == TestInfoMode.timRecording) {
      /// Обновляем дату и время проведения моментом окончания теста
      _dt = DateTime.now();

      /// Вызвать расчет показателей
      _zeroing();
      _calculator = KfrCalculator(_data);
      _calculated = true;
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
    if (_calculated) {
      return _calculator.factor(0).value;
    }
    return 0.0;
  }

  /// Возвращает частоту дискретизации сигналов теста
  double freq() {
    return _freq;
  }

  bool isSaved () {
    return _isSaved;
  }

  void setSaved() {
    _isSaved = true;
  }

  List<DataBlock> data() {
    return _data;
  }

  /// Возвращает кол-во записей данных в тесте
  int dataSize() {
    return _data.length;
  }

  /// Возвращает запсиь данных теста
  DataBlock value(int i) {
    assert(i >= 0 && i < _data.length);
    return _data[i];
  }

  List<double> diagram() {
    if (_calculated) {
      return _calculator.diagram();
    }

    List<double> nulV = [];
    return nulV;
  }

  void _zeroing() {
      double midAX = 0;
      double midAY = 0;
      double midAZ = 0;
      double midGX = 0;
      double midGY = 0;
      double midGZ = 0;
      for (int i = 0; i < _data.length; ++i) {
        midAX += _data[i].ax;
        midAY += _data[i].ay;
        midAZ += _data[i].az;
        midGX += _data[i].gx;
        midGY += _data[i].gy;
        midGZ += _data[i].gz;
      }
      midAX /= _data.length;
      midAY /= _data.length;
      midAZ /= _data.length;
      midGX /= _data.length;
      midGY /= _data.length;
      midGZ /= _data.length;

      for (int i = 0; i < _data.length; ++i) {
        _data[i].ax = _data[i].ax - midAX;
        _data[i].ay = _data[i].ay - midAY;
        _data[i].az = _data[i].az - midAZ;
        _data[i].gx = _data[i].gx - midGX;
        _data[i].gy = _data[i].gy - midGY;
        _data[i].gz = _data[i].gz - midGZ;
      }
  }
}

/// Режимы работы: запись и обработка
enum TestInfoMode { timRecording, timWorking }
