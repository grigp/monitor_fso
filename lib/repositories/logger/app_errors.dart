

class AppErrors {
  List<String> _errors = [];

  void registerError(String msg) {
    _errors.add(msg);
  }

  String getLastError() {
    if(_errors.isNotEmpty) {
      return _errors[_errors.length - 1];
    }
    return '';
  }
}