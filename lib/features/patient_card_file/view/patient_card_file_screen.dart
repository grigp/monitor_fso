import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';
import '../../../uikit/widgets/back_screen_button.dart';

class PatientCardFileScreen extends StatefulWidget {
  const PatientCardFileScreen({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _PatientCardFileScreenState();
}

class _PatientCardFileScreenState extends State<PatientCardFileScreen> {
  late TextEditingController _textFio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    BackScreenButton(
                      onBack: () {
                        Navigator.pop(context);
                      },
                      hasBackground: false,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: Image.asset('lib/assets/icons/settings60.png'),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Пациент',
                        textScaler: TextScaler.linear(1.0),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'ФИО',
                  textAlign: TextAlign.left,
                  textScaler: TextScaler.linear(1.0),
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: _textFio,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  style: Theme.of(context).textTheme.headlineSmall,
                  onChanged: (String value) {},
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        // await saveValues();
                        // await widget.onAccept();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Сохранить',
                        textScaler: const TextScaler.linear(1.0),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Отмена',
                          textScaler: const TextScaler.linear(1.0),
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _textFio = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _textFio.dispose();
    super.dispose();
  }
}
