
import 'dart:async';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/repositories/source/abstract_driver.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../defines.dart';

const double diap = 10.0;

class AccelDriver extends AbstractDriver {
  final _pending = <DataBlock>[];

  double _ax = 0;
  double _ay = 0;
  double _az = 0;
  double _gx = 0;
  double _gy = 0;
  double _gz = 0;
  double _gsx = 0;
  double _gsy = 0;
  double _gsz = 0;
  double _midAX = 0;
  double _midAY = 0;
  double _midAZ = 0;
  double _midGX = 0;
  double _midGY = 0;
  double _midGZ = 0;
  late DataBlock _cur = DataBlock(ax: 0, ay: 0, az: 0, gx: 0, gy: 0, gz: 0);
  final int _freq = 50;
  final double _min = -diap;
  final double _max = diap;
  bool _isCalibratng = false;
  int _timeCalibration = durationStageCalibr;
  bool _isFilter = true;
  late StreamSubscription<AccelerometerEvent>? _streamAccel;
  late StreamSubscription<GyroscopeEvent>? _streamGyro;
  late Timer? _sendTimer;

  late Function _sendData;
  late Function _endCalibration;

  final List<DataBlock> _dataCalibrate = [];
  final List<DataBlock> _dataFilter = [];
  final int _fc = 15;
  final List<double> _koefs = [0.08, 0.23, 0.5, 0.8, 1.1, 1.4, 1.9, 2, 1.9, 1.4, 1.1, 0.8, 0.5, 0.23, 0.08];

  AccelDriver(){
    getSettings();
  }

  @override
  Future<int> getCounter() async {
    return 0;
  }

  @override
  Future<DataParams> init(Function func) async {
    _sendTimer = null;
    _streamAccel = null;
    _streamGyro = null;

    _startProcess();
    _sendData = func;
    DataParams pi = DataParams(freq: _freq, min: _min, max: _max);
    return pi;
  }

  @override
  Future<void> calibrate(Function func) async {
    _endCalibration = func;
    _midAX = 0;
    _midAY = 0;
    _midAZ = 0;
    _midGX = 0;
    _midGY = 0;
    _midGZ = 0;
    _gsx = 0;
    _gsy = 0;
    _gsz = 0;
    _isCalibratng = true;
  }

  @override
  Future<void> setMode(ChaningMode md) async {
  }

  @override
  Future<void> getSettings() async {
    const storage =  FlutterSecureStorage();
    String? stc = await storage.read(key: 'time_calibration');
    if (stc != null) {
      _timeCalibration = int.tryParse(stc)!;
    }

    String? stf = await storage.read(key: 'filtration');
    if (stf != null) {
      if (stf == "1") {
        _isFilter = true;
      } else {
        _isFilter = false;
      }
    }
  }

  @override
  Future<void> stop() async {
    _sendTimer?.cancel();
    _sendTimer = null;
    await _streamAccel?.cancel();
    _streamAccel = null;
    await _streamGyro?.cancel();
    _streamGyro = null;
  }

  void _startProcess() async {
    Duration sensorInterval = SensorInterval.gameInterval;
    await _streamAccel?.cancel();
    _streamAccel = null;
    _streamAccel = accelerometerEventStream(samplingPeriod: sensorInterval).listen((AccelerometerEvent event){
      _ax = event.x - _midAX;
      _ay = event.y - _midAY;
      _az = event.z - _midAZ;

      /// Добавляем данные в массив, хранящийся между передачами данных
      _pending.add(DataBlock(ax: _ax, ay: _ay, az: _az, gx: _gx, gy: _gy, gz: _gz));

      if (_isCalibratng){
        _dataCalibrate.add(DataBlock(ax: _ax, ay: _ay, az: _az,
            gx: _gx, gy: _gy, gz: _gz));
        if (_dataCalibrate.length >= _timeCalibration * _freq){
          _isCalibratng = false;
          for (int i = 0; i < _dataCalibrate.length; ++i){
            _midAX += _dataCalibrate[i].ax;
            _midAY += _dataCalibrate[i].ay;
            _midAZ += _dataCalibrate[i].az;
            _midGX += _dataCalibrate[i].gx;
            _midGY += _dataCalibrate[i].gy;
            _midGZ += _dataCalibrate[i].gz;
          }
          _midAX /= _dataCalibrate.length;
          _midAY /= _dataCalibrate.length;
          _midAZ /= _dataCalibrate.length;
          _midGX /= _dataCalibrate.length;
          _midGY /= _dataCalibrate.length;
          _midGZ /= _dataCalibrate.length;
          _gsx = 0;
          _gsy = 0;
          _gsz = 0;

          _dataCalibrate.clear();
          _endCalibration();
        }
      }
    },
      onError: (e, st) {
        GetIt.I<Talker>().handle(e, st, 'sensor stream error');
        _sendTimer?.cancel();
        _sendTimer = null;
      },
    );

    /// Таймер передачи данных с частотой 50 Гц
    _sendTimer?.cancel();
    _sendTimer = null;
    _sendTimer = Timer.periodic(const Duration(microseconds: 20000), (Timer timer){
      /// Если список вдруг пуст, то передаем предыдущее
      if (_pending.isEmpty) {
        _sendData(_cur.ax, _cur.ay, _cur.az, _cur.gx, _cur.gy, _cur.gz);
        return;
      }
      var ax = 0.0, ay = 0.0, az = 0.0, gx = 0.0, gy = 0.0, gz = 0.0;
      for (final b in _pending) {
        ax += b.ax; ay += b.ay; az += b.az;
        gx += b.gx; gy += b.gy; gz += b.gz;
      }
      final n = _pending.length;
      _pending.clear();
      ax /=  n; ay /= n; az /= n; gx /= n; gy /= n; gz /= n;


      _cur = DataBlock(ax: ax, ay: ay, az: az, gx: gx, gy: gy, gz: gz);

      ///< Фильтрация
      if (_isFilter) {
        _dataFilter.add(DataBlock(ax: ax, ay: ay, az: az,
            gx: _gsx, gy: _gsy, gz: _gsz));
        if (_dataFilter.length > _fc) {
          _dataFilter.removeAt(0);
        }
      }

      if (_isFilter) {
        if (_dataFilter.length >= _fc) {
          for (int i = 0; i < _dataFilter.length; ++i) {
            _cur.ax = _cur.ax + _koefs[i] * _dataFilter[i].ax;
            _cur.ay = _cur.ay + _koefs[i] * _dataFilter[i].ay;
            _cur.az = _cur.az + _koefs[i] * _dataFilter[i].az;
            _cur.gx = _cur.gx + _koefs[i] * _dataFilter[i].gx;
            _cur.gy = _cur.gy + _koefs[i] * _dataFilter[i].gy;
            _cur.gz = _cur.gz + _koefs[i] * _dataFilter[i].gz;
          }
          _cur.ax /= _fc;
          _cur.ay /= _fc;
          _cur.az /= _fc;
          _cur.gx /= _fc;
          _cur.gy /= _fc;
          _cur.gz /= _fc;
        }
      }
      _sendData(_cur.ax, _cur.ay, _cur.az, _cur.gx, _cur.gy, _cur.gz);

    });

    await _streamGyro?.cancel();
    _streamGyro = null;
    _streamGyro = gyroscopeEventStream(samplingPeriod: sensorInterval).listen((GyroscopeEvent event){
      _gx = event.x - _midGX;
      _gy = event.y - _midGY;
      _gz = event.z - _midGZ;
      _gsx += _gx;
      _gsy += _gy;
      _gsz += _gz;
      // _func(_gx, _gy, _gz);
    });
  }


}