import 'package:monitor_fso/repositories/defines.dart';

/// Класс данных о записи теста
class RecordTest {
  String uid;
  DateTime dt;
  String patientUid;
  String methodicUid;
  double kfr;
  double freq;
  late List<DataBlock> data = [];

  RecordTest({
    required this.uid,
    required this.dt,
    required this.patientUid,
    required this.methodicUid,
    required this.kfr,
    required this.freq,
  }) {
    data.clear();
  }

  void add(DataBlock block) {
    data.add(block);
  }

  int size() {
    return data.length;
  }

  DataBlock value(int idx) {
    assert(idx >= 0 && idx < data.length, 'incorrect index : $idx');
    return data[idx];
  }
}

const String uidMethodicRec = '8193a154-5302-456c-b5c7-1c8957b36635';
