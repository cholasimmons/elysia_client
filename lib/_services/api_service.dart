import 'dart:convert';
import 'package:http/http.dart' as http;
import '../_models/user_model.dart';
import '../_utils/constants.dart';

class ApiService {
  static const String baseUrl = Constants.host;

  static Future<User?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return User.fromJson(responseData);
    } else {
      throw Exception('Failed to login');
    }
  }
}
