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

/// Признак того, что программа является демо версией
bool isDemoVersion = false;

///< Версия программы
///< uvHome         - домашняя, индивидуальная
///< uvProfessional - профессиональная
enum UserVersion {uvHome, uvProfessional}

/// Версия программы. Если нужна другая, перекомментировать, пересобрать
//UserVersion userVersion = UserVersion.uvProfessional;
UserVersion userVersion = UserVersion.uvHome;

/// Кол-во записей в демонстрационной версии
int maxRecordsCount = 25;

/// Дата окончания работы демонстрационной версии
DateTime dateDeadline = DateTime(2025, 9, 1);

const int durationStageWait = 15;
const int durationStageCalibr = 2;
const int durationStageRec = 30;

