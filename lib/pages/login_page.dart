import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();

  void login(BuildContext context) async {
    bool success = await AuthService.login(email.text, password.text);

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Column(
        children: [
          TextField(
            controller: email,
            decoration: InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: password,
            decoration: InputDecoration(labelText: "Password"),
          ),
          ElevatedButton(onPressed: () => login(context), child: Text("Login")),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: Text("Register"),
          ),
        ],
      ),
    );
  }
}
