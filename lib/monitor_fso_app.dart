import 'package:flutter/material.dart';
import 'package:flutter_device_imei/flutter_device_imei.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/features/activation/enter_activation_code_screen/view/enter_activation_code_screen.dart';
import 'package:monitor_fso/features/invitation_screen/view/invitation_screen.dart';
import 'package:monitor_fso/router/routes.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'assets/colors/colors.dart';

//import 'features/invitation_screen/view/invitation_screen.dart';

class MonitorFsoApp extends StatelessWidget {
  const MonitorFsoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _getDeviceIMEI();

    Widget screen = const EnterActivationCodeScreen(title: 'Введите код активации');
//    Widget screen = const InvitationScreen(title: 'Мониторинг ФСО');
    // Widget screen = _adapterState == BluetoothAdapterState.on
    //     ? const InvitationToConnectScreen(title: 'Электростимуляторы texel')
    //     : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(
      title: 'Monitor FSO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: tealBackgroundColor),
        useMaterial3: true,
      ),
//      routes: routes,
      home: screen,

      navigatorObservers: [
        TalkerRouteObserver(
          GetIt.I<Talker>(),
        )
      ],
    );
  }

  void _getDeviceIMEI() async {
    String? imei = await FlutterDeviceImei.instance.getIMEI();
  }

}
