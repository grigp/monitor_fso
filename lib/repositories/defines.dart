class DataParams {
  int freq;
  double min;
  double max;

  DataParams({
    required this.freq,
    required this.min,
    required this.max
  });
}

class DataBlock {
  double ax;
  double ay;
  double az;
  double gx;
  double gy;
  double gz;

  DataBlock({
    required this.ax,
    required this.ay,
    required this.az,
    required this.gx,
    required this.gy,
    required this.gz,
  });
}

///< Раделитель целой и дробной части числа при экспорте сигнала
///< dsPoint - точка
///< dsComma - запятая
enum DecimalSeparator {dsPoint, dsComma}

///< Точка входа в тест
///< rteInvitation - окно приглашения
///< rteTestsNew - окно списка тестов, новый тест
///< rteTestsOpen - окно списка тестов, открыть тест
enum RunTestEntrance {rteInvitation, rteTestsNew, rteTestsOpen}

int screenCounter = 0;
