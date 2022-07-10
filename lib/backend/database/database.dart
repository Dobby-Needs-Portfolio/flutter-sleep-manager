import 'package:sleep_manager_app/exception/InitializationException.dart';
import 'package:sqflite/sqflite.dart';

import '../Util.dart';

class DatabaseManager {
  // Singleton instance using factory keyword
  static final DatabaseManager _instance = DatabaseManager._initialize();
  /// This Constructor returns singleton instance of DatabaseManager
  factory DatabaseManager() => _instance;
  DatabaseManager._initialize() {
    // Create/Open database from file
    String databaseFileName = Util.env('DATABASE_FILENAME');
    getDatabasesPath()
        .then((databasePath) => '$databasePath/$databaseFileName')
        .then((createdFilePath) => openDatabase(createdFilePath))
        .then((createdDatabase) => _database = createdDatabase);

  }
  // Database instance
  late final Database _database;

}

