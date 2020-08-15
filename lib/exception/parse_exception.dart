class ParseException implements Exception {

  final String msg = '解析异常';

  String toString() {
    return msg;
  }
}
