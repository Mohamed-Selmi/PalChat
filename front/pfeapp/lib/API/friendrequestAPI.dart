import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pfeapp/models/friendrequest.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FriendRequestAPI{
  static Future<List<FriendRequest>> fetchFriendRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
     const String apiUrl = 'http://172.20.128.1:8000/friends/show-friend-requests/';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
        if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final content = jsonData['content'] as List<dynamic>;
        return content.map((requestJson) {
      
          return FriendRequest(
                id:requestJson['id'],
                sender_id: requestJson['sender'],
                sender_username: requestJson['sender_username'],
                sender_picture_url: requestJson['sender_picture_url'],
                receiver_id: requestJson['receiver'],
                receiver_username: requestJson['receiver_username'],
                receiver_picture_url: requestJson['receiver_picture_url'],
                active_status: requestJson['active_status'],
                timestamp: DateTime.parse(requestJson['created_at']),
          );
        }).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
  print(e);
  throw Exception('Failed to connect to the server');
}
  }
static Future<List<FriendRequest>> fetchSentFriendRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
     const String apiUrl = 'http://172.20.128.1:8000/friends/sent-friend-requests/';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
        if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final content = jsonData['content'] as List<dynamic>;
        return content.map((requestJson) {
      
          return FriendRequest(
                id:requestJson['id'],
                sender_id: requestJson['sender'],
                sender_username: requestJson['sender_username'],
                sender_picture_url: requestJson['sender_picture_url'],
                receiver_id: requestJson['receiver'],
                receiver_username: requestJson['receiver_username'],
                receiver_picture_url: requestJson['receiver_picture_url'],
                active_status: requestJson['active_status'],
                timestamp: DateTime.parse(requestJson['created_at']),
          );
        }).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
  print(e);
  throw Exception('Failed to connect to the server');
}
  }



 static Future<bool> sendFriendRequest(int receiverUserId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  if (accessToken == null) {
    throw Exception('Access token not found');
  }
  
  const String apiUrl = 'http://172.20.128.1:8000/friends/send-friend-request/'; 
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json', 
      },
      body: jsonEncode({'receiving_user': receiverUserId}),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to send friend request';
      print('Error: $errorMessage');
      throw Exception(errorMessage);
    }
  } catch (e) {
    throw e;
  }
}

  static Future<bool> acceptFriendRequest(int requestId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    final String apiUrl = 'http://172.20.128.1:8000/friends/accept-friend-request/$requestId/'; 
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to accept friend request';
      print('Error: $errorMessage');
      throw Exception(errorMessage);
    }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<bool> declineFriendRequest(int requestId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    final String apiUrl = 'http://172.20.128.1:8000/friends/decline-friend-request/$requestId/'; 
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to decline  friend request';
      print('Error: $errorMessage');
      throw Exception(errorMessage);
    }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
    static Future<bool> cancelFriendRequest(int requestId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    final String apiUrl = 'http://172.20.128.1:8000/friends/cancel-friend-request/$requestId/'; 
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        return true;
      }else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to cancel friend request';
      print('Error: $errorMessage');
      throw Exception(errorMessage);
    }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
  static Future<bool> removeFriend(int friendId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  if (accessToken == null) {
    throw Exception('Access token not found');
  }
  
  const String apiUrl = 'http://172.20.128.1:8000/friends/remove-friend/'; 
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'friend_id': friendId}), 
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to remove friend ';
      print('Error: $errorMessage');
      throw Exception(errorMessage);
    }
  } catch (e) {
    throw Exception('Failed to connect to the server');
  }
}


}