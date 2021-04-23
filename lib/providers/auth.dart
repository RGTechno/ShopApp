import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryTime;
  Timer _autoTimer;

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryTime != null &&
        _expiryTime.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBOOQg4ASdvOAu4hGL6C8Rv44En55b1plk";
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData["expiresIn"],
          ),
        ),
      );
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryTime.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    }catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBOOQg4ASdvOAu4hGL6C8Rv44En55b1plk";
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData["expiresIn"],
          ),
        ),
      );
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryTime.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryTime = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryTime = null;
    if(_autoTimer!=null){
      _autoTimer.cancel();
      _autoTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
  }

  void autoLogout() {
    if(_autoTimer!= null){
      _autoTimer.cancel();
    }
    var timeToExpire = _expiryTime.difference(DateTime.now()).inSeconds;
    _autoTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
