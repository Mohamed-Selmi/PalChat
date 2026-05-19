// ignore_for_file: non_constant_identifier_names

class FriendRequest {
  final int id; 
  final int sender_id;
  final String sender_username;
  final String? sender_picture_url;
  final int receiver_id;
  final String receiver_username;
  final String? receiver_picture_url;
  final bool active_status;
  final DateTime timestamp;
  
  FriendRequest({
    required this.id,
    required this.sender_id,
    required this.sender_username,
    this.sender_picture_url,
    required this.receiver_id,
    required this.receiver_username,
    this.receiver_picture_url,
    required this.active_status,
    required this.timestamp,
  });
}

