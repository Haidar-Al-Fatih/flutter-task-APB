import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    final data = await ApiService.post("login", {
      "email": email,
      "password": password,
    });

    if (data['token'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data['token']);
      return true;
    }

    return false;
  }

  static Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    final data = await ApiService.post("register", {
      "name": name,
      "email": email,
      "password": password,
    });

    return data != null;
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<User?> getUser() async {
    final data = await ApiService.get("me");
    return User.fromJson(data);
  }

  static Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
