import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pfeapp/models/message.dart';

class ChatAPI {
  static Future<List<Message>> fetchRoomMessages(int conversationId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    final String url = 'http://192.168.1.3:8000/chat/room-messages/$conversationId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> content = responseData['content'] as List<dynamic>;
        
        List<Message> messages = content.map((json) => Message.fromMap(json)).toList();

        return messages;
      } else {
        throw Exception('Failed to load room messages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in: $e');
      throw e;
    }
  }
 


   Future<void> sendMessage(int conversation, String content, File? image) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  if (accessToken == null) {
    throw Exception('Access token not found');
  }
  const String apiUrl = 'http://192.168.1.3:8000/chat/create-message';
  try {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['Authorization'] = 'Bearer $accessToken';
    
    request.fields['conversation'] = conversation.toString();
    request.fields['content'] = content;

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        ),
      );
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) { 
      print('Message sent successfully');
    } else {
      throw Exception('Failed to send message: ${response.body}');
    }
  } catch (e) {
    throw Exception('Failed to connect to the server: $e');
  }
}


}