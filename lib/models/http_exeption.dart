class HttpExeption implements Exception{
  final String message;
  HttpExeption({required this.message});

   @override
  String toString() {
    return message;
  }
  
}