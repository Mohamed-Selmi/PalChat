import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';

  static Future<void> saveToken(String accessToken, String refreshToken) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessTokenKey, accessToken);
    await prefs.setString(refreshTokenKey, refreshToken);
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(refreshTokenKey);
  }

  static Future<void> deleteTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessTokenKey);
    await prefs.remove(refreshTokenKey);
  }
}
