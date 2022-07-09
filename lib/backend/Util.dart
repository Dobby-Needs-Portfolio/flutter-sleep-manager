import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sleep_manager_app/exception/data/DataFetchException.dart';

import '../exception/InitializationException.dart';

class Util {
  static bool _isInitialized = false;
  static Future<void> initialize() async {
    if (_isInitialized) {
      throw DuplicateInitException('backend.Util');
    }
    try {
      dotenv.load(fileName: 'assets/config/.env');
      _isInitialized = true;
    } catch (e) {
      throw InitializationFailException('backend.Util');
    }
  }

  /// Get the environment variable from .env file
  /// by searching [key] from parameter and return it as [String].
  ///
  /// Throws an [EnvFetchException] if the variable is not found
  static String env(String key) {
    var value = dotenv.env[key];
    if(value == null) {
    throw EnvFetchException(
      "Environment variable $key not found", "backend.util");
    }
    return value;
  }
}