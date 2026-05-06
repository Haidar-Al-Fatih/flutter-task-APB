import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  // Fungsi Login
  static Future<bool> login(String email, String password) async {
    final data = await ApiService.post("login", {
      "email": email,
      "password": password,
    });

    if (data['token'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Simpan Token
      await prefs.setString("token", data['token']);
      // Simpan Data User (Name, Email, NPM) agar bisa diakses offline sesuai tugas
      await prefs.setString("name", data['user']['name']);
      await prefs.setString("email", data['user']['email']);
      await prefs.setString("npm", data['user']['npm'].toString());
      return true;
    }
    return false;
  }

  // Fungsi Register (Ditambah field NPM)
  static Future<bool> register(
    String name,
    String email,
    String password,
    String npm,
  ) async {
    final data = await ApiService.post("register", {
      "name": name,
      "email": email,
      "password": password,
      "npm": npm,
    });
    // Jika register berhasil (status 201), return true
    return data != null;
  }

  // Ambil Token yang tersimpan
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Ambil Data User dari SharedPreferences (Tanpa hit API /me terus-menerus)
  static Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");
    String? email = prefs.getString("email");
    String? npm = prefs.getString("npm");

    if (name != null && email != null && npm != null) {
      return User(name: name, email: email, npm: npm);
    }
    return null;
  }

  // Fungsi Logout
  static Future<void> logout() async {
    // 1. Panggil API Logout di Laravel agar token di DB dihapus[cite: 1]
    await ApiService.post("logout", {});

    // 2. Hapus data di SharedPreferences lokal
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
