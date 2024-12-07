import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
class EditProfileAPI {
  Future<void> editProfile(String username,  File? picture) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    const String apiUrl = 'http://192.168.1.3:8000/accounts/edit';
       try {
      var request = http.MultipartRequest('PUT', Uri.parse(apiUrl));
      request.headers['Authorization'] = 'Bearer $accessToken';
      
      request.fields['username'] = username;

      if (picture != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'picture',
            picture.path,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

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
