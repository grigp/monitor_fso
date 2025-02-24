import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/features/results_screen/view/results_screen.dart';
import 'package:monitor_fso/repositories/database/db_defines.dart';
import 'package:monitor_fso/repositories/database/db_provider.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/database/test_data.dart';
import '../../../repositories/defines.dart';
import '../../../uikit/widgets/back_screen_button.dart';
import '../../../uikit/widgets/painters/graph.dart';
import '../../../uikit/widgets/painters/histogram.dart';

class TestResultScreen extends StatefulWidget {
  const TestResultScreen({
    super.key,
    required this.title,
    required this.testData,
  });

  final String title;
  final TestData testData;

  @override
  State<StatefulWidget> createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        Future.delayed(Duration.zero, () {
          if (!context.mounted) return;
          _closeScreen();
        });
      },
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: tealBackgroundColor,
        //   title: Text(widget.title),
        // ),
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
                          _closeScreen();
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
            Text(
              'КФР = ${num.parse(widget.testData.kfr().toStringAsFixed(0))} %',
              style: const TextStyle(
                color: tealDarkColor,
                fontStyle: FontStyle.italic,
                fontSize: 44,
                fontWeight: FontWeight.w700,
              ),
//                style: Theme.of(context).textTheme.displaySmall,
            ),
            SizedBox(
              height: 150,
              width: double.infinity,
              child: CustomPaint(
                painter: Histogram(data: widget.testData.diagram(), max: 100),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: CustomPaint(
                  painter: Graph(
                    widget.testData.data(),
                    widget.testData.freq().toInt(),
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!widget.testData.isSaved())
              FloatingActionButton(
                onPressed: _onSaveTest,
                heroTag: 'Save',
                tooltip: 'Сохранить',
                foregroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: Image.asset('lib/assets/icons/save48.png'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ++screenCounter;
  }

  void _onSaveTest() {
    setState(() {
      widget.testData.setSaved();
    });

    var rec = RecordTest(
      uid: widget.testData.uid(),
      dt: widget.testData.dateTime(),
      methodicUid: uidMethodicRec,
      kfr: widget.testData.kfr(),
      freq: widget.testData.freq(),
    );
    rec.data = widget.testData.data();

    GetIt.I<DbProvider>().addTest(rec);
  }

  void _closeScreen() async {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => const ResultsScreen(
        title: 'Результаты тестов',
      ),
      settings: const RouteSettings(name: '/results'),
    );
    Navigator.of(context).push(route);
  }
}
