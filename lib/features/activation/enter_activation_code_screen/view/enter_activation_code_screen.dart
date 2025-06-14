import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/features/activation/ask_for_activation_code_screen/view/ask_for_activation_code_screen.dart';
import 'package:monitor_fso/features/invitation_screen/view/invitation_screen.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

import '../../../../repositories/protect_manager/protect_manager.dart';
import '../../../../uikit/monfso_button.dart';

class EnterActivationCodeScreen extends StatefulWidget {
  const EnterActivationCodeScreen({super.key, required this.title});

  final String title;

  @override
  State<EnterActivationCodeScreen> createState() =>
      _EnterActivationCodeScreenState();
}

class _EnterActivationCodeScreenState extends State<EnterActivationCodeScreen> {
  late TextEditingController _textActivateKey;
  String _activationKey = "";

  @override
  void initState() {
    super.initState();
    _getActivationCode();
    _textActivateKey = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _textActivateKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                'Программа не активирована.\nВведите ключ активации',
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
                //  inputFormatters: [
                //   NumberTextInputFormatter(
                //     integerDigits: 2,
                //     decimalDigits: 0,
                //     maxValue: '10',
                //     allowNegative: false,
                //   )
                // ],
                onChanged: (String value) {
                  if (value != '') {
                    _activationKey = value;
                  }
                },
//                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  var isOK = await GetIt.I<ProtectManager>()
                      .isActivationKeyCorrect(_activationKey);
                  if (isOK) {
                    await GetIt.I<ProtectManager>()
                        .saveActivationKey(_activationKey);
                    _openInvitationScreen();
                  } else {
                    _msgActivationCodeIsNotCorrect();
                  }
                },
                child: const Text(
                  'Активировать',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                child: const Text(
                  'Запросить ключ активации',
                  textAlign: TextAlign.center,
                  textScaler: TextScaler.linear(1.0),
                  style: TextStyle(
                    color: Colors.blue, //Color.fromARGB(255, 100, 100, 50),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  _openAskForActivationCodeScreen();
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _getActivationCode() async {
    var key = await GetIt.I<ProtectManager>().getActivationKey();
    var ok = await GetIt.I<ProtectManager>().isActivationKeyCorrect(key);
    if (ok) {
      _openInvitationScreen();
    }
  }

  void _openInvitationScreen() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => const InvitationScreen(
        title: 'Мониторинг ФСО',
      ),
      settings: const RouteSettings(name: '/mon_fso'),
    );
    Navigator.of(context).push(route);
  }

  void _openAskForActivationCodeScreen() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => const AskForActivationCodeScreen(
        title: 'Запрос ключа активации',
      ),
      settings: const RouteSettings(name: '/ask_activation_code'),
    );
    Navigator.of(context).push(route);
  }

  void _msgActivationCodeIsNotCorrect() {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Неправильный ключ активации',
          textScaler: TextScaler.linear(1.0),
        ),
        actions: <Widget>[
          MonfsoButton.accent(
            onPressed: () => Navigator.pop(context, 'Close'),
            text: 'Закрыть',
            width: 120,
          ),
        ],
      ),
    );
  }
}
