class Conversation {
  final int id; // Added id field
  final String name;
  final String? last_message;
  final String? last_sent_user;

  Conversation({
    required this.id, // Updated constructor to include id
    required this.name,
    this.last_message,
    this.last_sent_user,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'], // Assigning id from JSON
      name: json['name'] ?? 'No Name',
      last_message: json['last_message'] ?? 'No Last Message',
      last_sent_user: json['last_sent_user'] ?? 'No Last Sent User',
    );
  }
}
