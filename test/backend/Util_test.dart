
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_manager_app/backend/Util.dart';
import 'package:sleep_manager_app/exception/data/DataFetchException.dart';

void main() async {
  group('[Util]: environment variable manage', () {
    test('Search Correct Value', () {
      dotenv.testLoad(fileInput: '''DATABASE_NAME=sleep_manager_app''');
      expect(Util.env('DATABASE_NAME'), 'sleep_manager_app');
    });
    test('Search incorrect value', () {
      dotenv.testLoad(fileInput: '''DATABASE_NAME=sleep_manager_app''');
      expect(() => Util.env('WRONG_KEY'), throwsA(isA<EnvFetchException>()));
    });
  });
}