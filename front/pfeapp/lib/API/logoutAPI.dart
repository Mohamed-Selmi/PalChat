import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pfeapp/homepage/loginview.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LogoutAPI{
    static Future<void> LogoutUser( BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    const String apiUrl = 'http://172.20.128.1:8000/accounts/logout';
    try {
      final response = await http.post(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $accessToken',
      });
       if (response.statusCode == 200) {
        // Successful logout
        print('User logged out successfully');
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      } else {
        // Handle error response
        print('Failed to logout: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error occurred during logout: $e');
    }
}
    }