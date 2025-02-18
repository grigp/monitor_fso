import 'package:flutter/material.dart';

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
          Navigator.of(context).popUntil(ModalRoute.withName('/'),
          );
        });
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
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
