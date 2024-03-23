import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class EditProfileAPI {
  Future<void> editProfile(String username, String pictureUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    const String apiUrl = 'http://192.168.1.3:8000/accounts/edit-profile/';
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'picture': pictureUrl,
        }),
      );
      if (response.statusCode == 200) {
        print('Profile updated successfully');
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
