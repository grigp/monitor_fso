import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/features/results_screen/widgets/test_title.dart';
import 'package:monitor_fso/repositories/database/db_provider.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/database/db_defines.dart';
import '../../../repositories/database/test_data.dart';
import '../../../repositories/defines.dart';
import '../../../uikit/monfso_button.dart';
import '../../../uikit/widgets/back_screen_button.dart';
import '../../../uikit/widgets/exit_program_dialog.dart';
import '../../record_screen/view/record_screen.dart';
import '../../settings_screen/view/settings_screen.dart';
import '../../test_result_screen/view/test_result_screen.dart';
import '../result_utils.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<RecordTest> _tests = [];
  bool _readed = false;
  String _uidHandler = '';

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
          showExitProgramDialog(context);
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
                          showExitProgramDialog(context);
                        },
                        hasBackground: false,
                        isClose: true,
                      ),
                      // const SizedBox(width: 10),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.asset('lib/assets/icons/hist60.png'),
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
            const Divider(
              height: 0,
              indent: 0,
              thickness: 1,
            ),
            if (_readed)
              Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate:
                        SliverChildListDelegate(_builldTestTitle(context)),
                      ),
                    ],
                  ),
              ),
            const SizedBox(height: 100),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    title: 'Настройки',
                    onAccept: () {},
                  ),
                  settings: const RouteSettings(name: '/select'),
                );
                Navigator.of(context).push(route);
              },
              heroTag: 'Settings',
              tooltip: 'Настройки',
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Image.asset('lib/assets/icons/settings48.png'),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              onPressed: _onNewTest,
              heroTag: 'NewTest',
              tooltip: 'Провести тест',
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Image.asset('lib/assets/icons/play48.png'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _readTestList();
    ++screenCounter;

    _uidHandler = GetIt.I<DbProvider>().addHandler(onDbChange);
  }

  @override
  void dispose() {
    GetIt.I<DbProvider>().removeHandler(_uidHandler);
    super.dispose();
  }

  /// Заполняет список тестов
  List<Widget> _builldTestTitle(BuildContext context) {
    var dtc = DateTime(2000, 1, 1, 0, 0, 0);
    List<Widget> retval = [];

    if (_tests.isEmpty) return retval;

    /// По списку от БД
    for (int i = _tests.length - 1; i >= 0; --i) {
      /// Если дата изменилась, то сначала выводим дату
      var dt = _tests[i].dt;
      if (dt.day != dtc.day || dt.month != dtc.month || dt.year != dtc.year) {
        retval.add(
          Container(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 0,
              left: 10,
              right: 10,
            ),
            child: Text(
              '${pdt(dt.day)}:${pdt(dt.month)}:${pdt(dt.year)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              textScaler: const TextScaler.linear(1.0),
            ),
          ),
        );
        dtc = dt;
      }

      /// А потом сам заголовок теста
      retval.add(
        TestTitle(
          test: _tests[i],
          isLast: false,
          //index == _tests.length - 1,
          onSelect: (RecordTest test) async {
            _openTest(context, test);
          },
          onDelete: (RecordTest test) async {
            final bool? isDelete = await _askDeleteTest(test.dt);
            if (isDelete!) {
              GetIt.I<DbProvider>().deleteTest(test.uid);
            }
          },
        ),
      );
    }

    return retval;
  }

  void _readTestList() async {
    _tests = await GetIt.I<DbProvider>().getListTests();
    setState(() {
      _readed = true;
    });
  }

  void _onNewTest() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => const RecordScreen(
        title: 'Запись',
      ),
      settings: const RouteSettings(name: '/record'),
    );
    Navigator.of(context).push(route);
  }

  void _openTest(BuildContext context, RecordTest test) async {
    test.data = await GetIt.I<DbProvider>().getTestData(test.uid);
    var testData = TestData.fromDb(test);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => TestResultScreen(
        title: 'Результаты теста',
        testData: testData,
      ),
      settings: const RouteSettings(name: '/test_result'),
    );
    Navigator.of(context).push(route);
  }

  /// Обработка сообщения об изменениив БД
  void onDbChange(DBEvents event, String testUid) {
    _readTestList();
  }

  Future<bool?> _askDeleteTest(DateTime dt) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Удалить тест\n${pdt(dt.day)}.${pdt(dt.month)}.${dt.year} ${pdt(dt.hour)}:${pdt(dt.minute)}:${pdt(dt.second)}?',
          textScaler: TextScaler.linear(1.0),
        ),
        actions: <Widget>[
          MonfsoButton.accent(
            onPressed: () {
              Navigator.pop(context, false);
            },
            text: 'Нет',
            width: 120,
          ),
          MonfsoButton.secondary(
            onPressed: () {
              Navigator.pop(context, true);
            },
            text: 'Да',
            width: 120,
          ),
        ],
      ),
    );
  }
}
