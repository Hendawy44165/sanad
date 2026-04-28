import 'package:sanad/core/constants/codes.dart';

class AppException implements Exception {
  final Codes code;
  final String? message;

  const AppException(this.code, [this.message]);

  @override
  String toString() {
    if (message != null) return "AppException: ${code.name} - $message";
    return "AppException: ${code.name}";
  }
}
