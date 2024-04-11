import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pfeapp/Mainpage/homeview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAPI {
  static Future<void> loginUser(String email, String password, BuildContext context) async {
    const String apiUrl = 'http://192.168.1.3:8000/accounts/login';

    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    final String encodedData = jsonEncode(data);

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: encodedData,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String accessToken = responseData['access']; 
        final String refreshToken = responseData['refresh']; 
          
        // Save tokens using shared_preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      } else {
        print('Failed to sign-in. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error while signing in: $error');
    }
  }
}
