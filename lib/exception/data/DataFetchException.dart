import 'package:sleep_manager_app/exception/ServiceException.dart';

class DataFetchException extends ServiceException {
  DataFetchException(super.message, super.package);
}

class EnvFetchException extends DataFetchException {
  EnvFetchException(super.message, super.package);
}