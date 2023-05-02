class HttpException implements Exception {
  //*If we simply print the exception, it will show 'Instance of HttpException'
  //*But we need a proper error message
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return message;
    // return super.toString();
  }
}
