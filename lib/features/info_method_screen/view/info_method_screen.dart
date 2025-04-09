import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';
import '../../../uikit/widgets/back_screen_button.dart';

class InfoMethodScreen extends StatefulWidget {
  const InfoMethodScreen({super.key, required this.title});

  final String title;

  @override
  State<InfoMethodScreen> createState() => _InfoMethodScreenState();
}

class _InfoMethodScreenState extends State<InfoMethodScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        Future.delayed(Duration.zero, () {
          if (!context.mounted) return;
          Navigator.pop(context, 0);
        });
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: tealBackgroundColor,
              width: double.infinity,
              height: 120,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      BackScreenButton(
                        onBack: () {
                          Navigator.pop(context, 0);
                        },
                        hasBackground: false,
                      ),
                      // const SizedBox(width: 10),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.asset('lib/assets/icons/info48.png'),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1.0),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'МЕТОДИКА ИССЛЕДОВАНИЯ',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Исследование проводится на жестком полу, босиком или в тонких синтетических носках.\n'
                        'Надеть поясной ремень с чехлом для смартфона. Расположить чехол сбоку на уровне крыла тазовой кости.\n'
                        ' - Выставить максимальный уровень громкости смартфона\n'
                        ' - Запустить Приложение monitor_fso\n'
                        ' - Нажать кнопку «+»\n'
                        ' - Установить параметры (по умолчанию: время ожидания 15с, время калибровки 2с, время записи 30с)\n'
                        ' - Нажать на кнопку «Пуск».\n'
                        ' - Поместить смартфон в чехол на поясе.\n'
                        ' - Занять удобную привычную вертикальную стойку с открытыми глазами, руки вдоль тела.\n'
                        ' - Закрыть глаза, не совершать никаких активных движений.\n'
                        '- После того, как начнут подаваться звуковые сигналы метронома – считать их количество\n'
                        ' - Когда прозвучит мелодия, исследование будет окончено.\n'
                        ' - Извлечь смартфон из чехла, посмотреть и сохранить результат ФСО в %.\n'
                        ' - Выйти из программы или провести новый тест',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
