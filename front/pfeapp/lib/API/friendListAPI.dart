// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pfeapp/models/user.dart';

class FriendListAPI {
  static Future<List<User>> fetchAllUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    const String apiUrl = 'http://192.168.1.3:8000/accounts/users';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        return jsonData.map((userJson) {
          return User(
            email: userJson['email'],
            username: userJson['username'],
            pictureUrl: userJson['picture_url'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
