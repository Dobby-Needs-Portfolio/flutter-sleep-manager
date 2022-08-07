import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sleep_manager_app/exception/data/DataFetchException.dart';
import 'package:sqflite/sqflite.dart';

import '../exception/InitializationException.dart';

class Util {
  static bool _isInitialized = false;
  static Future<void> initialize() async {
    if (_isInitialized) {
      throw DuplicateInitException('backend.Util');
    }
    try {
      // Operation 1
      await () async {
        dotenv.load(fileName: 'assets/config/.env');
      } ();
      // Operation 2
      await () async {
        _databaseInitialize();
      } ();

      _isInitialized = true;
    } catch (e) {
      throw InitializationFailException('backend.Util');
    }
  }

  static void _databaseInitialize() async {
    // Create/Open database from file
    String databaseFileName = Util.env('DATABASE_FILENAME');
    getDatabasesPath()
        .then((databasePath) => '$databasePath/$databaseFileName')
        .then((createdFilePath) => openDatabase(createdFilePath))
        .then((createdDatabase) => Get.put(createdDatabase));
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