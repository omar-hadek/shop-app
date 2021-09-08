import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Auth extends ChangeNotifier{
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  Future<void> signUp(String? email,String?  password) async{
    final url  = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAteSP9CcwvPNsampuT0fzHB1vOsjit9-U');
    http.post(url,body: json.encode(
      {
        'email':email,
        'password':password,
        'returnSecureToken':true
      }
    ));
  }

}