import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monitor_fso/uikit/monfso_button.dart';

void showExitProgramDialog(BuildContext context) {
  showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      title: const Text(
        'Выйти из программы?',
        textScaler: TextScaler.linear(1.0),
      ),
      actions: <Widget>[
        MonfsoButton.accent(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          text: 'Нет',
          width: 120,
        ),
        MonfsoButton.secondary(
          onPressed: () {
            exit(0);
          },
          text: 'Да',
          width: 120,
        ),
      ],
    ),
  );
}
