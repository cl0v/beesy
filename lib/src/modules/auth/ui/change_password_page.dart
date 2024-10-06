import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/usecases/change_password_usecase.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Senha'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: !_isOldPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Senha Anterior',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isOldPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isOldPasswordVisible = !_isOldPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              obscureText: !_isNewPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Nova Senha',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final (success, error) = await UserChangePasswordUsecase.call(
                  _oldPasswordController.text.trim(),
                  _newPasswordController.text.trim(),
                );

                if (!context.mounted) return;
                final text = success ?? error;
                final color = success != null
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.error;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(child: Text('$text')),
                    backgroundColor: color,
                  ),
                );
                if(success != null){
                  await Future.delayed(const Duration(seconds: 1));
                  if(!context.mounted) return;
                  context.pop();
                }
              },
              child: const SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text('Alterar Senha'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
