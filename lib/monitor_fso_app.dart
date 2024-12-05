import 'package:flutter/material.dart';

import 'features/invitation_screen/view/invitation_screen.dart';

class MonitorFsoApp extends StatelessWidget {
  const MonitorFsoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor FSO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InvitationScreen(title: 'Мониторинг ФСО'),
    );
  }
}

