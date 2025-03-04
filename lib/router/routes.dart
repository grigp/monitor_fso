import 'package:monitor_fso/features/invitation_screen/view/invitation_screen.dart';
import 'package:monitor_fso/features/record_screen/view/record_screen.dart';

import '../features/settings_screen/view/settings_screen.dart';
import '../features/test_result_screen/view/test_result_screen.dart';

final routes = {
  '/': (context) => const InvitationScreen(title: 'Мониторинг ФСО'),
//  '/record': (context) => const RecordScreen(title: 'Проведение теста'),
//  'result': (context) => const TestResultScreen(title: 'Результаты теста', testData: null,),
  '/settings': (context) =>
      const SettingsScreen(title: 'Настройки', onAccept: onAccept),
};

void onAccept() {

}
