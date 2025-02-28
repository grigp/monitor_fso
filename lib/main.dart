import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/repositories/database/db_provider.dart';
import 'package:monitor_fso/repositories/logger/app_errors.dart';
import 'package:monitor_fso/repositories/source/abstract_driver.dart';
import 'package:monitor_fso/repositories/source/accel_driver.dart';

import 'monitor_fso_app.dart';

void main() {
  GetIt.I.registerLazySingleton<DbProvider>(() => DbProvider());
  GetIt.I.registerLazySingleton<AbstractDriver>(() => AccelDriver());
  GetIt.I.registerLazySingleton<AppErrors>(() => AppErrors());

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((_) {
//    FlutterError.onError = (details) => (){};
    // runZonedGuarded(() => runApp(const MonitorFsoApp()), (e, st) {
    //
    // });
    runApp(const MonitorFsoApp());
  });
}
