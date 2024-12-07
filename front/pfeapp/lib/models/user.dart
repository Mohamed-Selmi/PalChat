class User {
  final int id; 
  final String email;
  final String username;
  final String? pictureUrl;
  User({
    required this.id,
    required this.email,
    required this.username,
    this.pictureUrl,
  });
}
