import 'package:flutter/material.dart';
import 'package:monitor_fso/router/routes.dart';

//import 'features/invitation_screen/view/invitation_screen.dart';

class MonitorFsoApp extends StatelessWidget {
  const MonitorFsoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor FSO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade100),
        useMaterial3: true,
      ),
//      home: const InvitationScreen(title: 'Мониторинг ФСО'),
      routes: routes,
    );
  }
}

