import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    loadUser(); // Ambil data saat halaman dibuka
  }

  void loadUser() async {
    // Ambil data user dari SharedPreferences lokal sesuai tugas
    User? localUser = await AuthService.getUser();
    setState(() {
      user = localUser;
    });
  }

  void logout() async {
    await AuthService.logout(); // Jalankan fungsi logout
    Navigator.pushReplacementNamed(context, '/login'); // Redirect ke Login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Profile"),
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          ), // Tombol Logout[cite: 1]
        ],
      ),
      body: Center(
        child: user == null
            ? CircularProgressIndicator()
            : Card(
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_circle, size: 80, color: Colors.blue),
                      SizedBox(height: 10),
                      Text(
                        "Nama: ${user!.name}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "NPM: ${user!.npm}",
                        style: TextStyle(fontSize: 16),
                      ), // Tampilkan NPM[cite: 1]
                      Text(
                        "Email: ${user!.email}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
