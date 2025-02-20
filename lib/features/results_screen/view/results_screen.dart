import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/features/results_screen/widgets/test_title.dart';
import 'package:monitor_fso/repositories/database/db_provider.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/database/db_defines.dart';
import '../../../uikit/widgets/back_screen_button.dart';
import '../../../uikit/widgets/exit_program_dialog.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<RecordTest> _tests = [];
  bool _readed = false;

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
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 10),
                  shrinkWrap: true,
                  children: <Widget>[..._builldTestTitle(context)],
                ),
              ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _onNewTest,
              heroTag: 'NewTest',
              tooltip: 'Провести тест',
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Image.asset('lib/assets/icons/play48.png'),
            ),
            const SizedBox(width: 40),
            FloatingActionButton(
              onPressed: _onDeleteTest,
              heroTag: 'DeleteTest',
              tooltip: 'Удалить тест',
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Image.asset('lib/assets/icons/delete48.png'),
            ),
            const SizedBox(width: 40),
            FloatingActionButton(
              onPressed: _onOpenTest,
              heroTag: 'OpenTest',
              tooltip: 'Открыть тест',
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Image.asset('lib/assets/icons/res_test48.png'),
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
  }

  List<Widget> _builldTestTitle(BuildContext context) {
    return _tests
        .mapIndexed(
          (test, index) => TestTitle(
            test: test,
            isLast: index == _tests.length - 1,
            onTap: () async {},
          ),
        )
        .toList();
  }

  void _readTestList() async {
    _tests = await GetIt.I<DbProvider>().getListTests();
    setState(() {
      _readed = true;
    });
  }

  void _onNewTest() {}

  void _onDeleteTest() {}

  void _onOpenTest() {}
}

extension ExtendedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
