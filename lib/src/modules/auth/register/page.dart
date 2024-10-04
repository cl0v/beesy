import 'package:flutter/material.dart';
import 'usecase.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _register() async {
    final (registered, loggedIn) = await RegisterUserUsecase.call(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (!registered) {
      setState(() {
        _errorMessage = "Dados de entrada inválidos ou email já cadastrado";
      });
      return;
    }
    if (registered) {
      if (loggedIn) {
        // TODO: Navega para a Home.
        return;
      }
      // TODO: Navega para a tela de Login.
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar")),
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
              onPressed: _register,
              child: const Text("Registrar"),
            ),
          ],
        ),
      ),
    );
  }
}
