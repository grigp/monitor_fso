import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/features/results_screen/view/results_screen.dart';
import 'package:monitor_fso/repositories/database/db_defines.dart';
import 'package:monitor_fso/repositories/database/db_provider.dart';
import 'package:monitor_fso/repositories/logger/app_errors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/database/test_data.dart';
import '../../../repositories/defines.dart';
import '../../../uikit/monfso_button.dart';
import '../../../uikit/widgets/back_screen_button.dart';
import '../../../uikit/widgets/painters/graph.dart';
import '../../../uikit/widgets/painters/histogram.dart';
import '../../results_screen/result_utils.dart';

class TestResultScreen extends StatefulWidget {
  const TestResultScreen({
    super.key,
    required this.title,
    required this.testData,
    required this.entrence,
  });

  final String title;
  final TestData testData;
  final RunTestEntrance entrence;

  @override
  State<StatefulWidget> createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  DecimalSeparator _ds = DecimalSeparator.dsComma;
  String _lastError = '';
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    var dt = widget.testData.dateTime();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        Future.delayed(Duration.zero, () {
          if (!context.mounted) return;
          _closeScreen();
        });
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: tealBackgroundColor,
              width: double.infinity,
              height: 120,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      BackScreenButton(
                        onBack: () {
                          _closeScreen();
                        },
                        hasBackground: false,
                      ),
                      // const SizedBox(width: 10),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.asset('lib/assets/icons/res_test.png'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          textScaler: const TextScaler.linear(1.0),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'Проведен ${pdt(dt.day)}.${pdt(dt.month)}.${pdt(dt.year)} ${pdt(dt.hour)}:${pdt(dt.minute)}:${pdt(dt.second)}',
              textScaler: const TextScaler.linear(1.0),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: tealDarkColor,
                fontSize: 14,
              ),
            ),
            Text(
              'ФСО = ${num.parse(widget.testData.kfr().toStringAsFixed(0))} %',
              textScaler: const TextScaler.linear(1.0),
              style: const TextStyle(
                color: tealDarkColor,
                fontStyle: FontStyle.italic,
                fontSize: 44,
                fontWeight: FontWeight.w700,
              ),
//                style: Theme.of(context).textTheme.displaySmall,
            ),
            if (_lastError != '') Text(_lastError),
            SizedBox(
              height: 150,
              width: double.infinity,
              child: CustomPaint(
                painter: Histogram(data: widget.testData.diagram(), max: 100),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: CustomPaint(
                  painter: Graph(
                    widget.testData.data(),
                    widget.testData.freq().toInt(),
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                final dir = Platform.isAndroid
                    ? await getExternalStorageDirectory()
                    : await getApplicationSupportDirectory();

                var dt = widget.testData.dateTime();
                String fn =
                    'accel_${pdt(dt.day)}_${pdt(dt.month)}_${pdt(dt.year)}_${pdt(dt.hour)}_${pdt(dt.minute)}_${pdt(dt.second)}.sig';
                var f = File('${dir?.path}/$fn');
                if (await f.exists()) {
                  await f.delete();
                }
                await f.writeAsString(_dataToString(widget.testData.data()));
                print('--- ${dir?.path}/$fn');
                Share.shareXFiles([XFile('${dir?.path}/$fn')],
                    text: 'Сигналы акселерограммы по x, y и z');

                //Share.share(dataToString(data));
              },
              heroTag: 'Share',
              tooltip: 'Поделиться',
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Image.asset('lib/assets/icons/share48_flat.png'),
            ),
            // if (!widget.testData.isSaved()) const SizedBox(width: 20),
            // if (!widget.testData.isSaved())
            if (!_isSaved) const SizedBox(width: 20),
            if (!_isSaved)
              FloatingActionButton(
                onPressed: _doSaveTest,
                heroTag: 'Save',
                tooltip: 'Сохранить',
                foregroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: Image.asset('lib/assets/icons/save48_flat.png'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _isSaved = widget.testData.isSaved();
    _getValues();
    ++screenCounter;
    _lastError = GetIt.I<AppErrors>().getLastError();
  }

  Future _doSaveUpdate() async {
    setState(() {
      _isSaved = true;
      widget.testData.setSaved();
    });
  }

  void _doSaveTest() async {
    await _onSaveTest();
  }

  Future _onSaveTest() async {
    await _doSaveUpdate();

    var rec = RecordTest(
      uid: widget.testData.uid(),
      dt: widget.testData.dateTime(),
      methodicUid: uidMethodicRec,
      kfr: widget.testData.kfr(),
      freq: widget.testData.freq(),
    );
    rec.data = widget.testData.data();

    await GetIt.I<DbProvider>().addTest(rec);
  }

  void _closeScreen() async {
    int? dr = -1;
    if (!widget.testData.isSaved()) {
      dr = await showDialog<int>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
            'Результаты не сохранены \nСохранить?',
            textScaler: TextScaler.linear(1.0),
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            MonfsoButton.accent(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              text: 'Да',
              width: 140,
            ),
            MonfsoButton.secondary(
              onPressed: () {
                Navigator.pop(context, -1);
              },
              text: 'Нет',
              width: 140,
            ),
            MonfsoButton.secondary(
              onPressed: () {
                Navigator.pop(context, 0);
              },
              text: 'Отмена',
              width: 140,
            ),
          ],
        ),
      );
    }

    if (dr == 1) {
      await _onSaveTest();
    }

    if (dr == 1 || dr == -1) {
      if (widget.entrence == RunTestEntrance.rteInvitation) {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => const ResultsScreen(
            title: 'Результаты тестов',
          ),
          settings: const RouteSettings(name: '/results'),
        );
        Navigator.of(context).push(route);
      } else if (widget.entrence == RunTestEntrance.rteTestsNew) {
        Navigator.of(context).popUntil(
          ModalRoute.withName('/results'),
        );
      } else if (widget.entrence == RunTestEntrance.rteTestsOpen) {
        Navigator.pop(context, 0);
      }
    }
  }

  String v2s(double val) {
    String sval = '$val';
    String retval = '';
    for (int i = 0; i < sval.length; ++i) {
      if (sval[i] != '.' && sval[i] != ',') {
        retval = '$retval${sval[i]}';
      } else {
        if (_ds == DecimalSeparator.dsPoint) {
          retval = '$retval.';
        } else if (_ds == DecimalSeparator.dsComma) {
          retval = '$retval,';
        }
      }
    }
//    print('-------------------- $_ds --- ${retval}');
    return retval;
  }

  String _dataToString(List<DataBlock> data) {
    String retval = 'AX\tAY\tAZ\tGX\tGY\tGZ\n';

    for (int i = 0; i < data.length; ++i) {
      retval =
          '$retval${v2s(data[i].ax)}\t${v2s(data[i].ay)}\t${v2s(data[i].az)}\t${v2s(data[i].gx)}\t${v2s(data[i].gy)}\t${v2s(data[i].gz)}\n';
      //     print('--------------------$i : $_ds ---- $retval');
    }
    return retval;
  }

  void _getValues() async {
    const storage = FlutterSecureStorage();
    String? stds = await storage.read(key: 'decimal_separator');
    if (stds != null) {
      _ds = DecimalSeparator.values[int.tryParse(stds)!];
    }
  }
}
