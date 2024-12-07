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
          id:jsonData['user_id'],
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
  static Future<List<User>> searchUsers(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  if (accessToken == null) {
    throw Exception('Access token not found');
  }

  final String apiUrl = 'http://192.168.1.3:8000/accounts/search/?username=$username';
  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      return jsonData.map((userJson) {
        return User(
          id:userJson['user_id'],
          email: userJson['email'],
          username: userJson['username'],
          pictureUrl: userJson['picture_url'],
        );
      }).toList();
    } else if (response.statusCode == 404) {
      throw Exception('No users found with the provided username');
    } else if (response.statusCode == 400) {
      throw Exception('Please provide a username query parameter');
    } else {
      throw Exception('Failed to load users');
    }
  } catch (e) {
    throw Exception('Failed to connect to the server');
  }
}

}