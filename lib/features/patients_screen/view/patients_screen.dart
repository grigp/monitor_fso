import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:monitor_fso/features/patient_card_file/view/patient_card_file_screen.dart';
import 'package:monitor_fso/features/patients_screen/widgets/patient_title.dart';
import 'package:monitor_fso/features/results_screen/view/results_screen.dart';
import 'package:monitor_fso/repositories/database/db_defines.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/database/db_provider.dart';
import '../../../repositories/defines.dart';
import '../../../uikit/widgets/back_screen_button.dart';
import '../../../uikit/widgets/exit_program_dialog.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  List<RecordPatient> _patients = [];
  bool _readed = false;
  String _uidHandler = '';

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
                      Expanded(
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.left,
                          textScaler: const TextScaler.linear(1.0),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
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
            const Divider(
              height: 0,
              indent: 0,
              thickness: 1,
            ),
            if (_readed)
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverList.builder(
                      itemCount: _patients.length,
                      itemBuilder: (context, index) {
                        return _buildPatientTitle(context, index);
                      },
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 100),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _onNewPatient,
              heroTag: 'NewPatient',
              tooltip: 'Новый пациент',
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Image.asset('lib/assets/icons/plus48_flat.png'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _readPatientsList();
    ++screenCounter;

    _uidHandler = GetIt.I<DbProvider>().addHandler(onDbChange);
  }

  @override
  void dispose() {
    GetIt.I<DbProvider>().removeHandler(_uidHandler);
    super.dispose();
  }

  void _onNewPatient() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => PatientCardFileScreen(
        title: 'Пациент',
        data: RecordPatient(
          uid: '',
          fio: '',
          born: DateTime(2001, 1, 1),
          sex: Sex.male,
          comment: '',
        ),
        assignValues: _onAddRecordPatient,
      ),
      settings: const RouteSettings(name: '/patient'),
    );
    Navigator.of(context).push(route);
  }

  void _onEditPatient(RecordPatient patient) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => PatientCardFileScreen(
        title: 'Пациент',
        data: RecordPatient(
          uid: patient.uid,
          fio: patient.fio,
          born: patient.born,
          sex: patient.sex,
          comment: patient.comment,
        ),
        assignValues: _onEditRecordPatient,
      ),
      settings: const RouteSettings(name: '/patient'),
    );
    Navigator.of(context).push(route);
  }

  /// Возврвщает тест для списка тестов
  Widget _buildPatientTitle(BuildContext context, int index) {
    return PatientTitle(
      patient: _patients[index],
      isLast: false,
      //index == _tests.length - 1,
      onSelect: (RecordPatient patient) async {
        _openTestsScreen(context, patient);
      },
      onEdit: (RecordPatient patient) async {
        _onEditPatient(patient);
      },
      onDelete: (RecordPatient patient) async {
        // final bool? isDelete = await _askDeleteTest(test.dt);
        // if (isDelete!) {
        //   GetIt.I<DbProvider>().deleteTest(test.uid);
        //   GetIt.I<Talker>().info('Delete test: ${test.dt}');
        // }
      },
    );
  }

  void _readPatientsList() async {
    /// Прочитаем
    _patients = await GetIt.I<DbProvider>().getListPatients();

    /// Оповестим виджет
    setState(() {
      _readed = true;
    });
  }

  /// Обработка сообщения об изменениив БД
  void onDbChange(DBEvents event, String patientUid) {
    _readPatientsList();
  }

  /// Добавление записи о пациенте
  void _onAddRecordPatient(RecordPatient data) async {
    await GetIt.I<DbProvider>().addPatient(data);
  }

  /// Редактирование записи о пациенте
  void _onEditRecordPatient(RecordPatient data) async {
    await GetIt.I<DbProvider>().editPatient(data);
  }

  void _onRemovePatient(RecordPatient data) async {}

  void _openTestsScreen(BuildContext context, RecordPatient patient) async {
    GetIt.I<Talker>().info('Open tests for patient: ${patient.fio}');

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => ResultsScreen(
        title: 'Результаты тестов',
      ),
      settings: const RouteSettings(name: '/results'),
    );
    Navigator.of(context).push(route);
  }

}
