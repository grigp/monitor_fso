import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/repositories/database/db_provider.dart';
import 'package:monitor_fso/repositories/logger/app_errors.dart';
import 'package:monitor_fso/repositories/source/abstract_driver.dart';
import 'package:monitor_fso/repositories/source/accel_driver.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'monitor_fso_app.dart';

void main() {
  FlutterError.onError =
      (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

  runZonedGuarded(() {
    GetIt.I.registerLazySingleton<DbProvider>(() => DbProvider());
    GetIt.I.registerLazySingleton<AbstractDriver>(() => AccelDriver());
    GetIt.I.registerLazySingleton<AppErrors>(() => AppErrors());

    GetIt.I.registerLazySingleton<Talker>(() => TalkerFlutter.init());
    GetIt.I<Talker>().info('Monitor FSO started ...');

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    ).then((_) {
      runApp(const MonitorFsoApp());
    });
  }, (error, stack) {
    GetIt.I<Talker>().handle(error, stack);
  });

  //runApp(const MonitorFsoApp());
}
