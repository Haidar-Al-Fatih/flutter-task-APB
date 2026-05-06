import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final npm = TextEditingController(); // Controller NPM[cite: 1]

  void register() async {
    // Validasi sederhana: Semua field wajib diisi[cite: 1]
    if (name.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty ||
        npm.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Semua field wajib diisi!")));
      return;
    }

    bool success = await AuthService.register(
      name.text,
      email.text,
      password.text,
      npm.text,
    );
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Register Berhasil! Silakan Login.")),
      );
      Navigator.pop(context); // Kembali ke halaman login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register User")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(labelText: "Nama Lengkap"),
            ),
            TextField(
              controller: npm,
              decoration: InputDecoration(labelText: "NPM"),
            ), // Field NPM[cite: 1]
            TextField(
              controller: email,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: Text("Daftar Sekarang")),
          ],
        ),
      ),
    );
  }
}
