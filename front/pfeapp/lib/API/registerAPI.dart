import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pfeapp/homepage/loginView.dart';
class RegisterAPI{
  static Future<void> signUpUser(BuildContext context, username, String email, String password) async {
  
  const String apiUrl = 'http://192.168.1.3:8000/accounts/register';
  
  final Map<String, dynamic> data = {
    'username': username,
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

    if (response.statusCode == 201) {
      print('Signup successful!');
         Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginView()),
                      );
    } else {
      print('Failed to signup. Error: ${response.statusCode}');
       final Map<String, dynamic> errors = jsonDecode(response.body);
      String? key = errors.keys.first;
      String value = errors[key][0];
      print(value);
      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:  Text(value),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                          ),
                        );
    }
  } catch (error) {
    print('Error while signing up: $error');
  }
}
}