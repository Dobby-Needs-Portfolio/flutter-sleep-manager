import 'ServiceException.dart';

class InitializationException extends ServiceException {
  InitializationException(String message, String package) : super(message, package);
}

class DuplicateInitException extends InitializationException {
  DuplicateInitException(String package) : super("Duplicate Initialization", package);
}

class NotInitializedException extends ServiceException {
  NotInitializedException(String package) : super("Called function Without Initialization", package);
}

class InitializationFailException extends ServiceException {
  InitializationFailException(String package) : super("Initialization Failed.", package);
}