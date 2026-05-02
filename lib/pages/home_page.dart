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
    loadUser();
  }

  void loadUser() async {
    user = await AuthService.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: user == null
            ? CircularProgressIndicator()
            : Text("Halo, ${user!.name}"),
      ),
    );
  }
}
