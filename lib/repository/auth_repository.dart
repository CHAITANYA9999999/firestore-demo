import 'dart:convert';

import 'package:firestore/models/user_model.dart';
import 'package:firestore/repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class AuthRepository1 extends GetxController {
  String? _token;
  // DateTime? _expiryDate;
  String? _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC8ztKaoaSsuFxVi_uwC4DZD3UKA7UF_FQ');
    try {
      final response = await http.post(
        url,
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
      _userId = responseData['localId'];
      // _expiryDate = DateTime.now()
      //     .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        // 'expiryDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData', userData);
      print(responseData);
      print(response.statusCode);
      print(response.body);
      update();
    } catch (error) {
      throw error;
    }
    // print(json.decode(response.body));
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  // Future<bool> tryAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userData')) {
  //     return false;
  //   }

  //   final extractedUserData =
  //       json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
  //   final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

  //   //*To check whether the user's token expired or not?
  //   if (expiryDate.isBefore(DateTime.now())) {
  //     return false;
  //   }
  //   _token = extractedUserData['token'] as String;
  //   _userId = extractedUserData['userId'] as String;
  //   _expiryDate = expiryDate;
  //   return true;
  // }
}
