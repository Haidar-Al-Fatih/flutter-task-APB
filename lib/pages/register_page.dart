import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final npmController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void register() async {
    // 1. Validasi Input Kosong
    if (nameController.text.isEmpty ||
        npmController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Semua field wajib diisi!")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 2. Jalankan fungsi register dari AuthService
      bool success = await AuthService.register(
        nameController.text,
        emailController.text,
        passwordController.text,
        npmController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Register Berhasil! Silakan Login."),
            backgroundColor: Colors.green,
          ),
        );
        // Kembali ke halaman login setelah sukses
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Register Gagal. Email mungkin sudah terdaftar."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan koneksi."),
          backgroundColor: Colors.orange,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Akun Baru"), centerTitle: true),
      body: SingleChildScrollView(
        // Agar tidak error overflow saat keyboard muncul
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Buat Akun Mahasiswa",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Input Nama
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nama Lengkap",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 15),

            // Input NPM
            TextField(
              controller: npmController,
              decoration: InputDecoration(
                labelText: "NPM",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.assignment_ind),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15),

            // Input Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 15),

            // Input Password
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 25),

            // Tombol Register / Loading
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register,
                    child: Text("DAFTAR SEKARANG"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),

            SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Sudah punya akun? Login di sini"),
            ),
          ],
        ),
      ),
    );
  }
}
