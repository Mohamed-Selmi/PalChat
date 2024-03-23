class User {
  final String email;
  final String username;
  final String? pictureUrl;
  User({
    required this.email,
    required this.username,
    this.pictureUrl,
  });
}
