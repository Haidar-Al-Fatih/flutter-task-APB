import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatelessWidget {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  void register(BuildContext context) async {
    await AuthService.register(name.text, email.text, password.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Column(
        children: [
          TextField(
            controller: name,
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: email,
            decoration: InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: password,
            decoration: InputDecoration(labelText: "Password"),
          ),
          ElevatedButton(
            onPressed: () => register(context),
            child: Text("Register"),
          ),
        ],
      ),
    );
  }
}
