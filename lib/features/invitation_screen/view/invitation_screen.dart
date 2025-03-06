import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/features/info_screen/view/info_screen.dart';
import 'package:monitor_fso/features/record_screen/view/record_screen.dart';
import 'package:monitor_fso/uikit/monfso_button.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/database/db_provider.dart';
import '../../../repositories/defines.dart';
import '../../results_screen/view/results_screen.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({super.key, required this.title});

  final String title;

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Text(
                  'Мониторинг функционального состояния организма - ФСО',
                  textAlign: TextAlign.center,
                  textScaler: TextScaler.linear(1.0),
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 155),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                color: Colors.black12,
                width: double.infinity,
                height: 270,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Image.asset('lib/assets/icons/screen_preview.png'),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                'Равновесие тела – интегральная характеристика функционального состояния организма',
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(1.0),
                style: TextStyle(
                  color: tealDarkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Мониторинг ФСО – залог адекватного контроля здоровья',
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(1.0),
                      style: TextStyle(
                        color: tealDarkColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    child: Image.asset('lib/assets/icons/info36.png'),
                    onTap: () {
                      _showInfoScreen();
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
//                            Navigator.of(context).pushNamed('/record');
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => const RecordScreen(
                          title: 'Запись',
                          entrence: RunTestEntrance.rteInvitation,
                        ),
                        settings: const RouteSettings(name: '/record'),
                      );
                      Navigator.of(context).push(route);
                    },
                    child: SizedBox(
                      width: 140,
                      height: 140,
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset('lib/assets/icons/new_test100.png'),
                            const Text(
                              'Провести тест',
                              textAlign: TextAlign.center,
                              textScaler: TextScaler.linear(1.0),
                              style: TextStyle(
                                color: tealDarkColor,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => const ResultsScreen(
                          title: 'Результаты тестов',
                        ),
                        settings: const RouteSettings(name: '/results'),
                      );
                      Navigator.of(context).push(route);
                    },
                    child: SizedBox(
                      width: 140,
                      height: 140,
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset('lib/assets/icons/hist100.png'),
                            const Text(
                              'Результаты',
                              textAlign: TextAlign.center,
                              textScaler: TextScaler.linear(1.0),
                              style: TextStyle(
                                color: tealDarkColor,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoScreen() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => const InfoScreen(
        title: 'Информация',
      ),
      settings: const RouteSettings(name: '/info'),
    );
    Navigator.of(context).push(route);
  }
}
