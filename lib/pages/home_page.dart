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
    // Ambil data user dari SharedPreferences lokal
    User? localUser = await AuthService.getUser();
    setState(() {
      user = localUser;
    });
  }

  void logout() async {
    await AuthService.logout(); // Jalankan fungsi logout
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login'); // Redirect ke Login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Mahasiswa"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            user == null
                ? CircularProgressIndicator()
                : Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.blueAccent.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            user!.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "NPM: ${user!.npm}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            user!.email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 30),

                          // Tombol navigasi ke fitur CRUD Lanjutan
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, '/tasks');
                            },
                            icon: Icon(Icons.assignment),
                            label: Text("KELOLA TUGAS SAYA"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
