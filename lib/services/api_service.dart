import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiService {
  // Gunakan 10.0.2.2 jika pakai Emulator Android
  // Gunakan 127.0.0.1 jika pakai Chrome[cite: 1]
  static const String baseUrl = "http://127.0.0.1:8000/api";

  static Future<Map<String, String>> headers() async {
    String? token = await AuthService.getToken();
    return {"Authorization": "Bearer $token", "Accept": "application/json"};
  }

  static Future post(String endpoint, Map data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$endpoint"),
      headers: await headers(),
      body: data,
    );
    return jsonDecode(response.body);
  }

  static Future get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$endpoint"),
      headers: await headers(),
    );
    return jsonDecode(response.body);
  }

  // Method untuk Update (PUT)
  static Future put(String endpoint, Map data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$endpoint"),
      headers: await headers(), // Mengambil Bearer Token otomatis
      body: data,
    );
    return jsonDecode(response.body);
  }

  // Method untuk Delete (DELETE)
  static Future delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$endpoint"),
      headers: await headers(),
    );
    return jsonDecode(response.body);
  }
}
