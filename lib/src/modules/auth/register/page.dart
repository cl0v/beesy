import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  bool loading = false;

  Future<void> _register() async {
    setState(() {
      loading = true;
    });

    final (regError, logError) = await RegisterUserUsecase.call(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      loading = false;
    });

    if (regError != null) {
      setState(() {
        _errorMessage = regError;
      });
      return;
    }

    if (logError != null) {
      if (!mounted) return;
      return context.go('/login');
    }

    return context.go('/');
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
            RichText(
              text: TextSpan(
                text: 'Já possui conta? ',
                style: Theme.of(context).textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: 'Entrar',
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.go('/login'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: loading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                        )
                      : const Text(
                          "Registrar",
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
