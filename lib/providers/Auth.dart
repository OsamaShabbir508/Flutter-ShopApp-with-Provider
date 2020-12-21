import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app_aftereid/Moels/HttpExcepytion.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  String get userId {
    return _userId;
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;

    notifyListeners();
  }

  String token() {
    if (_expiryDate.toString() != null &&
        (_token != null && _expiryDate.isAfter(DateTime.now()))) {
      return _token;
    } else
      return null;
  }

  Future<void> signUp(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA10F4LpEohuUWcF5XkyZfAwUGtTiSBhAE';
    try {
      final responce = await http.post(
        url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}),
      );
      print(responce.body);
      final responseData = json.decode(responce.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userId = responseData['localId'];
      notifyListeners();

      // DateTime.now().add(duration)
    } catch (error) {
      print(error.toString() + 'auth mian');
      throw error;
    }
  }

  Future<void> logIn(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA10F4LpEohuUWcF5XkyZfAwUGtTiSBhAE';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      print(response.body);
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print('Login m error aagya hai');
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userId = responseData['localId'];
      print(_token);
      print(userId);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
