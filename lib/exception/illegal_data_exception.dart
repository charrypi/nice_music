class IllegalDataException implements Exception {
  final String msg = "数据错误";

  String toString() {
    return msg;
  }
}
