// import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/features/info_method_screen/view/info_method_screen.dart';
import 'package:monitor_fso/features/test_result_screen/view/test_result_screen.dart';
import 'package:monitor_fso/repositories/database/db_provider.dart';
import 'package:monitor_fso/repositories/database/test_data.dart';
import 'package:monitor_fso/repositories/logger/app_errors.dart';
import 'package:monitor_fso/repositories/source/abstract_driver.dart';
import 'package:monitor_fso/uikit/widgets/exit_program_dialog.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/defines.dart';
import '../../../uikit/monfso_button.dart';
import '../../../uikit/widgets/back_screen_button.dart';
import '../../../uikit/widgets/painters/oscilloscope.dart';
import '../../results_screen/view/results_screen.dart';
import '../../settings_screen/view/settings_screen.dart';
import '../bloc/recording_bloc.dart';

enum RecordStages { stgNone, stgWait1, stgCalibrating, stgWait2, stgRecording }

class RecordScreen extends StatefulWidget {
  const RecordScreen({
    super.key,
    required this.title,
    required this.entrence,
  });

  final String title;
  final RunTestEntrance entrence;

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final _pcBloc = ProcessControlBloc(GetIt.I<AbstractDriver>());

  double _ax = 0;
  double _ay = 0;
  double _az = 0;
  double _gx = 0;
  double _gy = 0;
  double _gz = 0;
  int _n = 0;
  int _recCount = 0;
  final int _screenRate = 20;
  int _freq = 50;
  double _min = -10;
  double _max = -10;
  int _timeWait = 4;
  int _timeRec = 20;
  RecordStages _stage = RecordStages.stgNone;

//  final _database = GetIt.I<AbstractDatabaseRepository>();
  late TestData _testData;

  List<DataBlock> _block = [];

  late AudioPlayer player = AudioPlayer();

  /// Данные для записи
  List<OscillBlock> _blockView = [];

  /// Данные для осциллографа

  bool _isRecording = false;
  IconData _saveIcon = Icons.save_outlined;

  @override
  void initState() {
    _testData = TestData.fromRecord(_freq.toDouble());
    _pcBloc.add(InitSendDataEvent(func: getData));
    getSettings();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);

    ++screenCounter;

    super.initState();
  }

  @override
  void dispose() {
    _pcBloc.add(StopEvent());
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        body: BlocBuilder<ProcessControlBloc, RecordingState>(
          bloc: _pcBloc,
          builder: (context, state) {
            if (state is ProcessGetFreq) {
              String sTimer = getStageTime();
              String sStage = getStageComment();
              _freq = state.freq;
              _min = state.min;
              _max = state.max;
              return Center(
                child: Stack(
                  children: <Widget>[
                    Column(children: [
                      Container(
                        color: tealBackgroundColor,
                        width: double.infinity,
                        height: 120,
                        child: Column(
                          children: [
                            const SizedBox(height: 50),
                            Row(
                              children: [
                                // const SizedBox(width: 10),
                                BackScreenButton(
                                  onBack: () {
                                    _closeScreen();
                                  },
                                  hasBackground: false,
                                  isClose: true,
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: Image.asset(
                                      'lib/assets/icons/accel_icon.png'),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Проведение теста',
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    textScaler: TextScaler.linear(1.0),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                if (!_isRecording)
                                  GestureDetector(
                                    onTap: () {
                                      _showInfoScreen();
                                    },
                                    child: Icon(
                                      Icons.info,
                                      size: 35,
                                      color: Colors.teal.shade200,
                                    ),
                                    // child: Image.asset(
                                    //     'lib/assets/icons/info48_flat.png'),
                                  ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: tealDarkColor,
                        width: double.infinity,
                        height: 2,
                      ),
                      Expanded(
                        child: Row(children: [
                          Expanded(
                            child: SizedBox(
                              height: double.infinity,
                              child: CustomPaint(
                                painter: Oscilloscope(_blockView, _min, _max),
                                child: Text(
                                  /// TODO: Костыль. Но как сделать, чтоб обновлялась картинка...
                                  '${num.parse(_ax.toStringAsFixed(4))}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ]),
                    if (_isRecording)
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 200),
                            Text(
                              sStage,
                              textScaler: const TextScaler.linear(1.0),
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            Text(sTimer,
                                textScaler: const TextScaler.linear(1.0),
                                style:
                                    Theme.of(context).textTheme.displayLarge),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!_isRecording)
              FloatingActionButton(
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      title: 'Настройки',
                      onAccept: _onSettingsAccept,
                    ),
                    settings: const RouteSettings(name: '/select'),
                  );
                  Navigator.of(context).push(route);
                },
                heroTag: 'Settings',
                tooltip: 'Настройки',
                foregroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: Image.asset('lib/assets/icons/settings48_flat.png'),
              ),
            const SizedBox(width: 20),
            // if (!_isRecording) /// TODO: Закомментирована калибровка, ибо выполняется перед записью
            //   FloatingActionButton(
            //     onPressed: () {
            //       _pcBloc.add(CalibrationEvent(func: onEndCalibration));
            //     },
            //     heroTag: 'Calibrate',
            //     tooltip: 'Калибровка',
            //     foregroundColor: Theme.of(context).colorScheme.primary,
            //     backgroundColor: Theme.of(context).colorScheme.surface,
            //     child: Image.asset('lib/assets/icons/zeroing48.png'),
            //   ),
            // const SizedBox(width: 20),
            FloatingActionButton(
              onPressed: _setRecording,
              heroTag: 'Recording',
              tooltip: 'Запись',
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: _isRecording
                  ? Image.asset('lib/assets/icons/pause48_flat.png')
                  : Image.asset('lib/assets/icons/play48_flat.png'),
            ),
          ],
        ),
      ),
    );
  }

  void getSettings() async {
    const storage = FlutterSecureStorage();
    String? stw = await storage.read(key: 'time_wait');
    if (stw != null) {
      _timeWait = int.tryParse(stw)!;
    }
    String? str = await storage.read(key: 'time_record');
    if (str != null) {
      _timeRec = int.tryParse(str)!;
    }
    _pcBloc.add(UpdateParamsEvent());
    //
    // if (Platform.isAndroid) {
    //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //   print('Running on baseOS: ${Platform.operatingSystem} ${androidInfo.version.release}');
    //   GetIt.I<AppErrors>().registerError('${Platform.operatingSystem} ${androidInfo.version.release}');
    // }
  }

  void getData(
      double ax, double ay, double az, double gx, double gy, double gz) async {
    ++_n;
    _block.add(DataBlock(ax: ax, ay: ay, az: az, gx: gx, gy: gy, gz: gz));
    setState(() {
      _blockView.add(OscillBlock(chan0: ax, chan1: ay, chan2: az));
    });

    if (_n % (_freq / _screenRate) == 0) {
      setState(() {
        _ax = ax;
        _ay = ay;
        _az = az;
        _gx = gx;
        _gy = gy;
        _gz = gz;
      });
    }

    if (_isRecording) {
      if (_stage == RecordStages.stgRecording) {
        _testData.addValue(
            DataBlock(ax: ax, ay: ay, az: az, gx: gx, gy: gy, gz: gz));
        // await _database TODO: открыть
        //     .add(DataBlock(ax: ax, ay: ay, az: az, gx: gx, gy: gy, gz: gz));
      }

      ++_recCount;
      if (_stage == RecordStages.stgWait1) {
        if (_recCount == _timeWait * _freq) {
          _recCount = 0;
          _stage = RecordStages.stgCalibrating;
          _pcBloc.add(CalibrationEvent(func: onEndCalibration));
        }
      } else if (_stage == RecordStages.stgWait2) {
        if (_recCount == 1 * _freq) {
          _recCount = 0;
          _stage = RecordStages.stgRecording;
        }
      } else if (_stage == RecordStages.stgRecording) {
        if (_recCount == _timeRec * _freq) {
          _isRecording = false;
          _recCount = 0;
          _stage = RecordStages.stgNone;
          // await _database.setParams(_freq);  TODO: открыть
          _finishRecord();
          _playWithOK();
          setState(() {
            _saveIcon = Icons.save_outlined;
          });
        }
      }
    }
  }

  void _playWithOK() async {
    try {
      bool isEnableSound = true;
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        // GetIt.I<AppErrors>().registerError('${Platform.operatingSystem} ${androidInfo.version.release}');
        try {
          /// Разрешаем звук на андроидах с версией больше 10
          isEnableSound = int.parse(androidInfo.version.release) >= 10;
        } catch (e) {
          isEnableSound = false;
        }
      }

      if (isEnableSound) {
        await player.setSource(AssetSource('sounds/ok.wav'));
        await player.resume();
      }
    } catch (e) {
      GetIt.I<AppErrors>().registerError(e.toString());
    }
  }

  void onEndCalibration() async {
    if (_isRecording) {
      _recCount = 0;
      _stage = RecordStages.stgWait2;
    }
  }

  void _setRecording() async {
    _isRecording = !_isRecording;
    _recCount = 0;
    setState(() {
      if (_isRecording) {
        _saveIcon = Icons.save_rounded;
      } else {
        _saveIcon = Icons.save_outlined;
      }
    });

    ///! Остановили запись
    if (!_isRecording) {
      _stage = RecordStages.stgNone;
//      _finishRecord();
    } else {
      _stage = RecordStages.stgWait1;
    }
    _testData.clear();
  }

  String getStageTime() {
    if (_stage == RecordStages.stgCalibrating ||
        _stage == RecordStages.stgRecording) {
      return '${num.parse((_recCount / _freq).toStringAsFixed(1))} сек';
    } else if (_stage == RecordStages.stgWait1) {
      return '${num.parse((_timeWait - (_recCount / _freq)).toStringAsFixed(1))} сек';
    } else if (_stage == RecordStages.stgWait2) {
      return ''; //'''${num.parse((1 - (_recCount / _freq)).toStringAsFixed(1))} сек';Усачев хочет, чтобы сообщения не было
    }
    return '';
  }

  String getStageComment() {
    if (_stage == RecordStages.stgWait1) {
      return 'До калибровки';
    } else if (_stage == RecordStages.stgCalibrating) {
      return 'Калибровка';
    } else if (_stage == RecordStages.stgWait2) {
      return ''; //'''До записи';          Усачев хочет, чтобы сообщения не было
    } else if (_stage == RecordStages.stgRecording) {
      return 'Запись $_timeRec сек';
    }
    return '';
  }

  void _finishRecord() async {
    await _testData.finish();

    _pcBloc.add(StopEvent());

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => TestResultScreen(
        title: 'Результаты теста',
        entrence: widget.entrence,
        testData: _testData,
      ),
      settings: const RouteSettings(name: '/test_result'),
    );
    Navigator.of(context).push(route);
  }

  void _onSettingsAccept() {
    getSettings();
  }

  void _closeScreen() {
    if (_isRecording) {
      _isRecording = false;
      _closeScreenRecord();
    } else {
      _closeScreenPrepare();
    }
  }

  void _closeScreenPrepare() {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Тест не проведен. Выйти?',
          textScaler: TextScaler.linear(1.0),
        ),
        actions: <Widget>[
          MonfsoButton.accent(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            text: 'Нет',
            width: 120,
          ),
          MonfsoButton.secondary(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
              _pcBloc.add(StopEvent());
              if (screenCounter == 1) {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const ResultsScreen(
                    title: 'Результаты тестов',
                  ),
                  settings: const RouteSettings(name: '/results'),
                );
                Navigator.of(context).push(route);
              } else {
                Navigator.of(context).popUntil(
                  ModalRoute.withName('/results'),
                );
              }
            },
            text: 'Да',
            width: 120,
          ),
        ],
      ),
    );
  }

  void _closeScreenRecord() {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Запись прервана. Отменить проведение теста?',
          textScaler: TextScaler.linear(1.0),
        ),
        actions: <Widget>[
          MonfsoButton.accent(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            text: 'Нет',
            width: 120,
          ),
          MonfsoButton.accent(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
              _pcBloc.add(StopEvent());
              if (screenCounter == 1) {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const ResultsScreen(
                    title: 'Результаты тестов',
                  ),
                  settings: const RouteSettings(name: '/results'),
                );
                Navigator.of(context).push(route);
              } else {
                Navigator.of(context).popUntil(
                  ModalRoute.withName('/results'),
                );
              }
            },
            text: 'Да',
            width: 120,
          ),
        ],
      ),
    );
  }

  void _showInfoScreen() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => const InfoMethodScreen(
        title: 'Информация',
      ),
      settings: const RouteSettings(name: '/info'),
    );
    Navigator.of(context).push(route);
  }
}
