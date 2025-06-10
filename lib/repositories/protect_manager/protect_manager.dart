import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_device_imei/flutter_device_imei.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ProtectManager {
  /// Возвращает код imei мобильного устройства
  Future<String?> getDeviceIMEI() async {
    return await FlutterDeviceImei.instance.getIMEI();
  }

  /// Создает строку запроса, используя переданное имя поьзователя и imei устройства
  Future<String> encodeACRequestString(String name) async {
    String src = '$name#${await getDeviceIMEI()}'.toLowerCase();

    String dst = '';
    for (int i = 0; i < src.length; ++i) {
      var sCode = _getCharCode(src[i]);
      dst = '$dst$sCode';
    }
    return dst;
  }

  /// Получает код imei, используя ключ активации,
  /// сравнивает его с imei устройства и
  /// Возвращает true. если совпадают
  Future<bool> isActivationKeyCorrect(String key) async {
    /// Преобразование ключа активации в imei
    List<int> r = [0, 0, 0, 0];
    List<int> code = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    Set<int> idxR = {0, 6, 12, 18};
    Set<int> idxDef = {5, 11, 17};

    int nc = 0;
    int nr = 0;
    for (int i = 0; i < key.length; ++i) {
      /// случайные опорные числа
      if (idxR.contains(i)) {
        try {
          r[nr] = int.parse(key[i], radix: 16);
        } catch (e) {
          GetIt.I<Talker>().info('Неправильный формат кода активации');
        }
        ++nr;
      } else

      /// Основные числа ключа
      if (!idxDef.contains(i)) {
        if (nc < 16) {
          try {
            code[nc] = int.parse(key[i], radix: 16);
          } catch (e) {
            GetIt.I<Talker>().info('Неправильный формат кода активации');
          }
        }
        ++nc;
      }
    }
    if (kDebugMode) {
      print('-------------  $r    $code');
    }

    /// Преобразование
    String imeiFromKey = '';
    for (int i = 0; i < code.length; ++i) {
      int c = code[i];
      if (code[i] >= r[i % 4]) {
        code[i] -= r[i % 4];
      } else {
        code[i] = code[i] - r[i % 4] + 16;
      }
      if (kDebugMode) {
        print('----- $i: ${c}  ${r[i % 4]}    ${code[i].toRadixString(16)}');
      }
      imeiFromKey = imeiFromKey + code[i].toRadixString(16);
    }

    /// Код imei устройства
    String? imeiFromDevice = await getDeviceIMEI();
    if (kDebugMode) {
      print('-------------  $r    $code');
      print('-------------  $imeiFromKey');
      print('-------------  $imeiFromDevice');
    }

    return imeiFromKey == imeiFromDevice;
  }

  /// Сохраняет ключ активации
  Future saveActivationKey(String key) async {
    var fnKey = '${await getDatabasesPath()}/a.key';
    File file = File(fnKey);
    await file.writeAsString(key);
  }

  /// Читает ключ активации
  Future<String> getActivationKey() async {
    var fnKey = '${await getDatabasesPath()}/a.key';
    File file = File(fnKey);
    String retval = '';
    if (await file.exists()) {
      retval = await file.readAsString();
    }
    return retval;
  }

  /// Возвращает код символа из таблицы
  String _getCharCode(String char) {
    for (int i = 0; i < _codeTable.length; ++i) {
      if (_codeTable[i] == char) {
        String s = '';
        if (i < 10) {
          s = '0${i + 1}';
        } else {
          s = '${i + 1}';
        }
        return s;
      }
    }
    return '';
  }

  /// Таблица для перекодировки символов имени и iemi в символы запроса.
  /// Коды - индексы list + 1
  final List<String> _codeTable = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
    'а',
    'б',
    'в',
    'г',
    'д',
    'е',
    'ё',
    'ж',
    'з',
    'и',
    'й',
    'к',
    'л',
    'м',
    'н',
    'о',
    'п',
    'р',
    'с',
    'т',
    'у',
    'ф',
    'х',
    'ц',
    'ч',
    'ш',
    'щ',
    'ъ',
    'ы',
    'ь',
    'э',
    'ю',
    'я',
    '_',
    '-',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    ' ',
    '#'
  ];
}
