import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exeption.dart';

import 'package:myshop/models/http_exeption.dart';
class Auth extends ChangeNotifier{
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  Future<void> _register(String? email,String? password,String queryString )async{
     
    final url  = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:${queryString}?key=AIzaSyAteSP9CcwvPNsampuT0fzHB1vOsjit9-U');
    try{
      final response = await http.post(url,body: json.encode(
      {
        'email':email,
        'password':password,
        'returnSecureToken':true
      }
        ));
     final responseData = json.decode(response.body);
     if(responseData['error'] != null) {
       throw HttpExeption(message: responseData['error']['message']);
     } 

    }catch(error){
       throw error;
    }
    
    
  }


  Future<void> signUp(String? email,String?  password) async{
    return _register(email, password,'signUp');
  }


  Future<void> signIn(String? email,String? password){
    return _register(email, password,'signInWithPassword');
  }

}