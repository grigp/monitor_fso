import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/database/db_defines.dart';

class TestTitle extends StatefulWidget {
  const TestTitle({
    super.key,
    required this.test,
    required this.isLast,
    required this.onTap,
  });

  final RecordTest test;
  final bool isLast;
//  final VoidCallback? onTap;
  final Function onTap;

  @override
  State<TestTitle> createState() => _TestTitleState();
}

class _TestTitleState extends State<TestTitle> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.test);
//        widget.onTap?.call(widget.test);
      },
      child: _buildTitle(context, theme),
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    var dt = widget.test.dt;
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 0,
        left: 10,
        right: 10,
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(
                    '${_pdt(dt.day)}.${_pdt(dt.month)}.${dt.year}',
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  Text(
                    '${_pdt(dt.hour)}:${_pdt(dt.minute)}:${_pdt(dt.second)}',
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    textScaler: const TextScaler.linear(1.0),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                children: [         
                  Text(
                    'КФР = ${num.parse(widget.test.kfr.toStringAsFixed(0))}%',
                    style: theme.textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  LinearProgressIndicator(
                    value: widget.test.kfr.toInt() / 100,
                    minHeight: 20,
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: white,
//                  color: Colors.yellow,
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: 12),
          if (!widget.isLast)
            const Padding(
              padding: EdgeInsets.only(left: 58),
              child: Divider(
                height: 0,
                indent: 0,
                thickness: 1,
              ),
            ),
        ],
      ),
    );
  }

  String _pdt(int part) {
    String retval = '$part';
    if (retval.length < 2) {
      retval = '0$retval';
    }
    return retval;
  }
}
