import 'package:dio/dio.dart';

class TokenAPI {
  Future<Response> Authtoken(email, password) async {
    const String api = "http://192.168.1.3:8000/api/token/";
    Response response = await Dio().post(
      api,
      data: {"email": email, "password": password},
      options: Options(
        headers: {"Content-Type": "application/json"},
      ),
    );
    return response;
  }
}