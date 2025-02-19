import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';
import '../../../uikit/widgets/back_screen_button.dart';
import '../../../uikit/widgets/exit_program_dialog.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
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
          ],
        ),
        // body: BlocBuilder<ResultBloc, ResultState>(
        //   bloc: _database,
        //   builder: (context, state) {
        //     if (state is DataLoaded) {
        //       // List<DataBlock> data = _zeroing(state.data);
        //       // var kfr = KfrCalculator(data);
        //       return Center();
        //     }
        //   },
        // ),
      ),
    );
  }
}
