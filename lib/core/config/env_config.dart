import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();
  static String get apiUrl => dotenv.env['API_URL'] ?? "";
  static String get appName => dotenv.env['APP_NAME'] ?? "";
  static bool get showDebugBanner => dotenv.env['DEBUG'] == "TRUE";
}
