import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pfeapp/models/conversation.dart';
class ManageGroupAPI{

final String baseUrl = "http://192.168.1.3:8000/chat";


  static Future<Map<String, dynamic>> CreateGroup(String name) async {
  // Retrieve access token from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  if (accessToken == null) {
    throw Exception('Access token not found');
  }
  final response = await http.post(
    Uri.parse('http://192.168.1.3:8000/chat/create-group/'),
    headers: {
      'Authorization': 'Bearer $accessToken', // Include access token in headers
    },
    body: {
      'name': name,
    },
  );

  if (response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to create group');
  }
}

    static Future<String?> addMemberToGroup(int groupId, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      return 'Access token not found';
    }

    final String apiUrl = 'http://192.168.1.3:8000/chat/group-detail/$groupId/add-members/';
    Map<String, dynamic> requestBody = {
      'email': email,
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return null; 
      } else {
        return 'Failed to add user to group: ${response.statusCode}';
      }
    } catch (e) {
      return 'Exception while adding user to group: $e';
    }
  }

  static Future<Map<String, dynamic>> getGroupDetail(int groupId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    const String apiUrl = 'http://192.168.1.3:8000/chat/group-detail/';
    try {
      final response = await http.get(
        Uri.parse('$apiUrl$groupId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch group detail');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }


  static Future<List<Conversation>> fetchUserConversations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    const String apiUrl = 'http://192.168.1.3:8000/chat/user-chatrooms/';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

     if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final content = jsonData['content'] as List<dynamic>;
          return content.map((conversationJson) {
            return Conversation(
              id: conversationJson['id'],
              name: conversationJson['name'],
              last_message: conversationJson['last_message'],
              last_sent_user: conversationJson['last_sent_user__username'].toString(),
            );
          }).toList();
        } else {
          throw Exception('Failed to load conversations');
        }

            } catch (e) {
              throw Exception('Failed to connect to the server');
            }
          }
        }
