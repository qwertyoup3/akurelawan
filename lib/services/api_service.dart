import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class ApiService {
  // Login Endpoint
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['token'] ?? data['access_token'];

      // Simpan JWT Token ke local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      return true;
    }
    return false;
  }

  // Get User Profile (/auth/me)
  static Future<UserModel?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/auth/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  // Get Events List
  static Future<List<EventModel>> getEvents({
    String search = '',
    int page = 1,
  }) async {
    final response = await http.get(
      Uri.parse(
        '${AppConstants.baseUrl}/events?search=$search&page=$page&per_page=10',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['data'] ?? data;
      return list.map((e) => EventModel.fromJson(e)).toList();
    }
    return [];
  }
}
