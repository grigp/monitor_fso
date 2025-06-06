import 'package:flutter_device_imei/flutter_device_imei.dart';

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

  /// Возвращает код символа из таблицы
  String _getCharCode(String char) {
    for (int i = 0; i < _codeTable.length; ++ i) {
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
