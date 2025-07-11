import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/database/db_defines.dart';
import '../../../uikit/widgets/back_screen_button.dart';
import '../../results_screen/result_utils.dart';

class PatientCardFileScreen extends StatefulWidget {
  const PatientCardFileScreen({
    super.key,
    required this.title,
    required this.data,
    required this.assignValues,
  });

  final String title;
  final RecordPatient data;
  final Function assignValues;

  @override
  State<StatefulWidget> createState() => _PatientCardFileScreenState();
}

class _PatientCardFileScreenState extends State<PatientCardFileScreen> {
  String _uid = '';
  late TextEditingController _textFio;
  DateTime? _born = DateTime(2000, 1, 1);
  Sex _sex = Sex.male;
  late TextEditingController _textComment;

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
                  textScaler: TextScaler.linear(1.0),
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: _textFio,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  style: Theme.of(context).textTheme.headlineSmall,
                  onChanged: (String value) {
                    // print("${_textFio.text}");
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Дата рождения',
                      textScaler: TextScaler.linear(1.0),
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    GestureDetector(
                        child: Text(
                          '${pdt(_born!.day)}.${pdt(_born!.month)}.${_born!.year}',
                          textScaler: TextScaler.linear(1.0),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        onTap: () {
                          _selectDate();
                        }),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Пол',
                      textScaler: TextScaler.linear(1.0),
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    SegmentedButton<Sex>(
                      segments: const <ButtonSegment<Sex>>[
                        ButtonSegment<Sex>(
                          value: Sex.male,
                          label: Text('Муж'),
                        ),
                        ButtonSegment<Sex>(
                          value: Sex.female,
                          label: Text('Жен'),
                        ),
                      ],
                      selected: <Sex>{_sex},
                      onSelectionChanged: (Set<Sex> newSelection) {
                        setState(() {
                          _sex = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Комментарий',
                  textScaler: TextScaler.linear(1.0),
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: _textComment,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  style: Theme.of(context).textTheme.headlineSmall,
                  onChanged: (String value) {
//                    print("${_textComment.text}");
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        await widget.assignValues(
                          RecordPatient(
                            uid: _uid,
                            fio: _textFio.text,
                            born: _born!,
                            sex: _sex,
                            comment: _textComment.text,
                          ),
                        );
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
    _uid = widget.data.uid;
    if (_uid == '') {
      _uid = const Uuid().v1();
    }
    _textFio = TextEditingController(text: widget.data.fio);
    _textComment = TextEditingController(text: widget.data.comment);
    _born = widget.data.born;
    _sex = widget.data.sex;
  }

  @override
  void dispose() {
    _textFio.dispose();
    _textComment.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _born,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      cancelText: 'Отмена',
      confirmText: 'OK',
      helpText: 'Дата пождения',
    );

    if (pickedDate != null) {
      setState(() {
        _born = pickedDate;
      });
    }
  }
}
