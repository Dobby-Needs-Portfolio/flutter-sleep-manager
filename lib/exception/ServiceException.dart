class ServiceException implements Exception {
  String message;
  String package;
  ServiceException(this.message, this.package);
}