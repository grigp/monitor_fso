import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';
import '../../../uikit/widgets/back_screen_button.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key, required this.title});

  final String title;

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
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
                        child: Image.asset('lib/assets/icons/res_test.png'),
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
            const Text(
              'ТЕОРЕТИЧЕСКОЕ ОБОСНОВАНИЕ МЕТОДА',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  'Функциональное состояние организма (ФСО) – уровень физиологической, психической и социальной адаптации человека, обусловленный состоянием и активностью функциональных систем организма (здоровьем) и определяющий его жизнедеятельность и работоспособность.\n'
                  'Ухудшение ФСО возникает при болезни, утомлении, воздействии алкоголя и наркотиков и других негативных факторов.\n'
                  'Уровень ФСО может быть определен по качеству равновесия тела, как интегральной характеристике функций организма.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const Text(
              'ФИЗИОЛОГИЧЕСКОЕ ОПИСАНИЕ',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  'Качество динамической стабилизации тела в вертикальном положении оценивается по данным трехкоординатного акселерометра смартфона. Хорошее качество равновесия тела характеризуется преобладанием малых ускорений, а плохое – больших ускорений.\n'
                  'Доля преобладания малых ускорений, выраженная в процентах, характеризует качество равновесия тела и отражает уровень ФСО. В результате исследования Вы получаете одну цифру уровня ФСО в процентах.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const Text(
              'МЕТОДИКА ИССЛЕДОВАНИЯ',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  'Исследование проводится на жестком полу, босиком или в тонких синтетических носках. Надеть поясной ремень с чехлом для смартфона. Расположить чехол сбоку на уровне крыла тазовой кости.\n'
                  ' - Запустить Приложение monitor_fso\n'
                  ' - Нажать кнопку «Пуск»\n'
                  ' - Рекомендуемые параметры: время ожидания 15с, время калибровки 2с, время записи 30с.\n'
                  ' - При нажатии на кнопку «Центровка, калибровка» происходит коррекция акселерограмм сообразно положения смартфона.\n'
                  ' - Нажать на кнопку «Запуск теста».\n'
                  ' - Поместить смартфон в чехол на поясе.\n'
                  ' - Занять удобную привычную вертикальную стойку с открытыми глазами, руки вдоль тела.\n'
                  ' - Закрыть глаза, не совершать никаких активных движений.\n'
                  ' - Когда прозвучит мелодия, исследование будет окончено.\n'
                  ' - Извлечь смартфон из чехла, посмотреть и сохранить результат ФСО в %.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
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
