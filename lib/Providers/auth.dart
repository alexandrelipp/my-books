import 'dart:convert';

import 'package:flutter/material.dart';
import '../assets/secret.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  String _idUser;

  String get token {
    return (_token!=null && _idUser!=null)? _token:null;
  }

  String get idUser {
    return _idUser;
  }
  Future<void> signIn(String email, String password) async {
   
    final response = await http.post(
      signInurl,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final responseData=json.decode(response.body);
    if (response.statusCode==200){
      _token=responseData['idToken'];
      _idUser=responseData['localId'];
      notifyListeners();
      return;
    }
    throw AuthException(responseData['error']['message']);
  }
}

class AuthException implements Exception{
  final String message;

  AuthException(this.message);

  String toString(){
    return this.message;
  }
}