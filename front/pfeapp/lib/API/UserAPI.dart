import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pfeapp/models/user.dart';
class UserAPI{
  static Future<User?> fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    const String apiUrl = 'http://192.168.1.3:8000/accounts/user';
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['user'];
        return User(
          email: jsonData['email'],
          username: jsonData['username'],
          pictureUrl: jsonData['picture_url'],
        );
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}