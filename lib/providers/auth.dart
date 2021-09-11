import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exeption.dart';

import 'package:myshop/models/http_exeption.dart';

class Auth extends ChangeNotifier {
  String? _token;
  DateTime _expiryDate = DateTime.now();
  late String _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _register(
      String? email, String? password, String queryString) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:${queryString}?key=AIzaSyAteSP9CcwvPNsampuT0fzHB1vOsjit9-U');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpExeption(message: responseData['error']['message']);
      }

      _userId = responseData['localId'];
      _token = responseData['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String? email, String? password) async {
    return _register(email, password, 'signUp');
  }

  Future<void> signIn(String? email, String? password) {
    return _register(email, password, 'signInWithPassword');
  }
}
