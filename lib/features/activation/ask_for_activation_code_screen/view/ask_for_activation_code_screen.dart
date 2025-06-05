import 'package:flutter/material.dart';

class AskForActivationCodeScreen extends StatefulWidget {
  const AskForActivationCodeScreen({super.key, required this.title});

  final String title;

  @override
  State<AskForActivationCodeScreen> createState() =>
      _AskForActivationCodeScreenState();
}

class _AskForActivationCodeScreenState
    extends State<AskForActivationCodeScreen> {
  late TextEditingController _textActivateKey;

  @override
  void initState() {
    super.initState();
    _textActivateKey = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _textActivateKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                'Запрос кода активации',
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(1.0),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Ваше имя',
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(1.0),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              TextField(
                controller: _textActivateKey,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                style: Theme.of(context).textTheme.headlineSmall,
                onChanged: (String value) {
                  if (value != '') {
//                    _timeCalibr = int.tryParse(value)!;
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
//                  _openInvitationScreen();
                },
                child: const Text(
                  'Запросить код активации',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
