import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:shopping/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _id;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _id;
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _expiryDate = expiryDate;
    _id = extractedUserData['id'];
    // print(_token);
    // print(_id);
    // print(_expiryDate);
    notifyListeners();
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticateUser(
      String email, String password, String signupMode) async {
    final _url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$signupMode?key=AIzaSyDsN5qnD5KdreGl5xwWQ5VlwsXdn6annKA';
    try {
      final response = await http.post(
        _url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _id = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'id': _id,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> logOut() async {
    _token = null;
    _id = null;
    _expiryDate = null;
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  Future<void> signUp(String email, String password) async {
    return await _authenticateUser(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return await _authenticateUser(email, password, 'signInWithPassword');
  }
}
