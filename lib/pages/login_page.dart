import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false; // Untuk menampilkan loading indicator

  void login() async {
    // Validasi input sederhana
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email dan Password tidak boleh kosong!")),
      );
      return;
    }

    setState(() {
      isLoading = true; // Munculkan loading saat klik tombol
    });

    try {
      // Menjalankan fungsi login dari AuthService
      bool success = await AuthService.login(
        emailController.text,
        passwordController.text,
      );

      if (success) {
        // Jika berhasil, langsung pindah ke Home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Tampilkan pesan error jika gagal (email/pass salah)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email atau password salah"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Menangani jika ada error koneksi ke server
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal terhubung ke server. Pastikan backend jalan!"),
          backgroundColor: Colors.orange,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // Matikan loading apa pun hasilnya
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LOGIN"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Masuk ke Akun",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
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

            // Mengganti tombol dengan Loading Indicator jika sedang proses
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: login,
                    child: Text("LOGIN"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),

            SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: Text("Belum punya akun? Daftar di sini"),
            ),
          ],
        ),
      ),
    );
  }
}
