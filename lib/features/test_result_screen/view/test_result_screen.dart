import 'package:flutter/material.dart';

import '../../../repositories/database/test_data.dart';
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
          Navigator.of(context).popUntil(
            ModalRoute.withName('/'),
          );
        });
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                    'КФР = ${num.parse(widget.testData.kfr().toStringAsFixed(0))} %',
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: Histogram(data: widget.testData.diagram(), max: 100),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: double.infinity,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
