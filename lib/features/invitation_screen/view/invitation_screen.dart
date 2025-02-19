
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/uikit/monfso_button.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/database/db_provider.dart';
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
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: tealBackgroundColor,
                    width: double.infinity,
                    height: 380,
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
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
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Image.asset('lib/assets/icons/main_icon.png'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: tealDarkColor,
                    width: double.infinity,
                    height: 3,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Равновесие тела – интегральная характеристика функционального состояния организма',
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.linear(1.0),
                    style: TextStyle(
                      color: tealDarkColor,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Мониторинг ФСО – залог адекватного контроля здоровья',
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.linear(1.0),
                    style: TextStyle(
                      color: tealDarkColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/record');
                          },
                          child: SizedBox(
                            width: 140,
                            height: 140,
                            child: Center(
                              child: Column(
                                children: [
                                  Image.asset('lib/assets/icons/play100.png'),
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
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResultsScreen(
                                  title: 'Результаты тестов',
                                ),
                              ),
                            );
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
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
