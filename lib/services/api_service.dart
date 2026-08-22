import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event_model.dart';
import '../utils/constants.dart';

class ApiService {
  // 1. LOGIN: Ambil data users dari MockAPI dan cocokkan email
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/users'),
      );

      if (response.statusCode == 200) {
        List users = jsonDecode(response.body);

        // Cari user berdasarkan email
        final user = users.firstWhere(
          (u) => u['email'] == email,
          orElse: () => null,
        );

        if (user != null) {
          // Simpan sesi login sederhana menggunakan SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', 'mock_jwt_token_${user['id']}');
          await prefs.setString('user_role', user['role'] ?? 'organizer');
          await prefs.setString('user_name', user['name'] ?? 'User');
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Login Network Error: $e');
      return false;
    }
  }

  // 2. GET EVENTS: Ambil daftar event dari MockAPI
  static Future<List<EventModel>> getEvents({
    String search = '',
    int page = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/events'),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        List<EventModel> events = data
            .map((json) => EventModel.fromJson(json))
            .toList();

        // Jika ada parameter search, filter secara lokal dari hasil MockAPI
        if (search.isNotEmpty) {
          events = events
              .where(
                (event) =>
                    event.title.toLowerCase().contains(search.toLowerCase()) ||
                    event.description.toLowerCase().contains(
                      search.toLowerCase(),
                    ),
              )
              .toList();
        }

        return events;
      }
      return [];
    } catch (e) {
      debugPrint('Get Events Network Error: $e');
      return [];
    }
  }
}
