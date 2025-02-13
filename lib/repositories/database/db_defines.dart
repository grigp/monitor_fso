import 'package:monitor_fso/repositories/defines.dart';

/// Класс данных о записи теста
class RecordTest {
  String uid;
  DateTime dt;
  String methodicUid;
  late List<DataBlock> data;

  RecordTest({
    required this.uid,
    required this.dt,
    required this.methodicUid,
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
