import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/defines.dart';
import '../../../uikit/widgets/back_screen_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen(
      {super.key, required this.title, required this.onAccept});

  final String title;
  final Function onAccept;

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _textTimeWait;
  late TextEditingController _textTimeCalibr;
  late TextEditingController _textTimeRec;
  bool _isReady = false;

  int _timeWait = 4;
  int _timeCalibr = 1;
  int _timeRec = 20;

  ///< Разделитель целой и дробной частей числа
  DecimalSeparator _ds = DecimalSeparator.dsComma;

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
                    const Text(
                      'Параметры',
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(1.0),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              const Text(
                'Время ожидания, с',
                textScaler: TextScaler.linear(1.0),
                style: TextStyle(fontSize: 18),
              ),
              const Spacer(),
              if (_isReady)
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _textTimeWait,
                    style: Theme.of(context).textTheme.headlineSmall,
                    inputFormatters: [
                      NumberTextInputFormatter(
                        integerDigits: 2,
                        decimalDigits: 0,
                        maxValue: '20',
                        allowNegative: false,
                      )
                    ],
                    onChanged: (String value) {
                      if (value != '') {
                        _timeWait = int.tryParse(value)!;
                      }
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
              const SizedBox(width: 20),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              const Text(
                'Время калибровки, с',
                textScaler: TextScaler.linear(1.0),
                style: TextStyle(fontSize: 18),
              ),
              const Spacer(),
              if (_isReady)
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: _textTimeCalibr,
                    style: Theme.of(context).textTheme.headlineSmall,
                    inputFormatters: [
                      NumberTextInputFormatter(
                        integerDigits: 2,
                        decimalDigits: 0,
                        maxValue: '10',
                        allowNegative: false,
                      )
                    ],
                    onChanged: (String value) {
                      if (value != '') {
                        _timeCalibr = int.tryParse(value)!;
                      }
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
              const SizedBox(width: 20),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              const Text(
                'Время записи, с',
                textScaler: TextScaler.linear(1.0),
                style: TextStyle(fontSize: 18),
              ),
              const Spacer(),
              if (_isReady)
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _textTimeRec,
                    style: Theme.of(context).textTheme.headlineSmall,
                    inputFormatters: [
                      NumberTextInputFormatter(
                        integerDigits: 2,
                        decimalDigits: 0,
                        maxValue: '60',
                        allowNegative: false,
                      )
                    ],
                    onChanged: (String value) {
                      if (value != '') {
                        _timeRec = int.tryParse(value)!;
                      }
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Разделитель частей числа',
            textScaler: TextScaler.linear(1.0),
            style: TextStyle(fontSize: 20),
          ),
          SegmentedButton<DecimalSeparator>(
            segments: const <ButtonSegment<DecimalSeparator>>[
              ButtonSegment<DecimalSeparator>(
                value: DecimalSeparator.dsPoint,
                label: Text('Точка'),
              ),
              ButtonSegment<DecimalSeparator>(
                value: DecimalSeparator.dsComma,
                label: Text('Запятая'),
              ),
            ],
            selected: <DecimalSeparator>{_ds},
            onSelectionChanged: (Set<DecimalSeparator> newSelection) {
              setState(() {
                _ds = newSelection.first;
              });
            },
          ),
          const Expanded(child: SizedBox(height: double.infinity)),
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await saveValues();
                  await widget.onAccept();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Сохранить',
                  textScaler: TextScaler.linear(1.0),
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
    );
  }

  void getValues() async {
    const storage = FlutterSecureStorage();
    String? stw = await storage.read(key: 'time_wait');
    if (stw != null && stw != '') {
      _timeWait = int.tryParse(stw)!;
    }
    String? stc = await storage.read(key: 'time_calibration');
    if (stc != null && stc != '') {
      _timeCalibr = int.tryParse(stc)!;
    }
    String? str = await storage.read(key: 'time_record');
    if (str != null && str != '') {
      _timeRec = int.tryParse(str)!;
    }
    String? stds = await storage.read(key: 'decimal_separator');
    if (stds != null && stds != '') {
      _ds = DecimalSeparator.values[int.tryParse(stds)!];
    }

    _textTimeWait = TextEditingController(text: _timeWait.toString());
    _textTimeCalibr = TextEditingController(text: _timeCalibr.toString());
    _textTimeRec = TextEditingController(text: _timeRec.toString());
    setState(() {
      _isReady = true;
    });
  }

  Future saveValues() async {
    const storage = FlutterSecureStorage();
    var s = _timeWait.toString();
    await storage.write(key: 'time_wait', value: s);
    s = _timeCalibr.toString();
    await storage.write(key: 'time_calibration', value: s);
    s = _timeRec.toString();
    await storage.write(key: 'time_record', value: s);
    s = _ds.index.toString();
    await storage.write(key: 'decimal_separator', value: s);
  }

  @override
  void initState() {
    super.initState();

    getValues();
  }

  @override
  void dispose() {
    _textTimeWait.dispose();
    _textTimeCalibr.dispose();
    _textTimeRec.dispose();
    super.dispose();
  }
}
