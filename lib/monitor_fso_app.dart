import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/router/routes.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'assets/colors/colors.dart';

//import 'features/invitation_screen/view/invitation_screen.dart';

class MonitorFsoApp extends StatelessWidget {
  const MonitorFsoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor FSO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: tealBackgroundColor),
        useMaterial3: true,
      ),
//      home: const InvitationScreen(title: 'Мониторинг ФСО'),
      routes: routes,
      navigatorObservers: [
        TalkerRouteObserver(
          GetIt.I<Talker>(),
        )
      ],
    );
  }
}
