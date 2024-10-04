import 'package:app/src/modules/auth/login/usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../pages/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController =
      TextEditingController(text: kDebugMode ? "user@example.com" : "");
  final TextEditingController _passwordController =
      TextEditingController(text: kDebugMode ? "password123" : "");
  String? _errorMessage;

  void _login() async {
    final (loggedIn) = await UserLoginUsecase.call(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (!loggedIn) {
      setState(() {
        _errorMessage = "Email ou senha inválidos";
      });
      return;
    }
    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null) ...[
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
