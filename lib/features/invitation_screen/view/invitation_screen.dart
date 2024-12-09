import 'package:flutter/material.dart';
import 'package:monitor_fso/uikit/monfso_button.dart';

import '../../../assets/colors/colors.dart';


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
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: greenBackgroundColor,
                    width: double.infinity,
                    height: 400,
                    child: Center(
                      child: Image.asset('lib/assets/icons/main_icon.png'),
                    ),
                  ),
                  Container(
                    color: filledAccentButtonColor,
                    width: double.infinity,
                    height: 3,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Равновесие тела – интегральная характеристика функционального состояния организма',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green.shade900,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    'Мониторинг ФСО – залог Вашего адекватного контроля здоровья',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green.shade900,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(''),
                  const Spacer(),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Center(
                            child:
                            MonfsoButton.accent(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/record');
                                // MaterialPageRoute route = MaterialPageRoute(
                                //   builder: (context) => const SelectDeviceScreen(
                                //     title: 'Мои стимуляторы',
                                //   ),
                                //   settings: const RouteSettings(name: '/select'),
                                // );
                                // Navigator.of(context).push(route);
                              },
                              text: 'Пройти тест',
                            ),
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child:
                            MonfsoButton.accent(
                              onPressed: () {
                                // MaterialPageRoute route = MaterialPageRoute(
                                //   builder: (context) => const SelectDeviceScreen(
                                //     title: 'Мои стимуляторы',
                                //   ),
                                //   settings: const RouteSettings(name: '/select'),
                                // );
                                // Navigator.of(context).push(route);
                              },
                              text: 'Результаты',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
