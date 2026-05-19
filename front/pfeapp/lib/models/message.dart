class Message {
  final String fromUser;
  final int? fromUserId;
  final String message;
  final DateTime timestamp;
  final String? imageUrl;
  Message({
    required this.fromUser,
    required this.fromUserId,
    required this.timestamp,
    required this.message,
    this.imageUrl,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    
    return Message(
      fromUserId: map['sender']['user_id'] as int?,
      fromUser: map['sender']['username'] ?? '',
      message: map['content'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? ''),
      imageUrl: map['picture_url'] ?? '',
    );
  }
}