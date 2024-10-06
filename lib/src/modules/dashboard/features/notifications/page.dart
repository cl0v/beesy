import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:flutter/material.dart';

import '../users/data/usecases/fetch_users.dart';
import 'data/usecases/send_notification.dart';

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({super.key});

  @override
  State<SendNotificationPage> createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  List<UserModel> users = [];

  late Future<List<UserModel>> futureFetchUser;

  UserModel? _selectedUser;

  @override
  void initState() {
    futureFetchUser = FetchUsersUsecase.call();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar Notificação'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título da Notificação',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Corpo da Notificação',
              ),
              maxLines: 3, // Permite múltiplas linhas para o corpo da mensagem
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<UserModel>>(
              future: futureFetchUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar usuários'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum usuário encontrado'));
                }

                final usersData = snapshot.data!;

                return Column(
                  children: [
                    Wrap(
                      spacing: 8.0,
                      children: users.map((user) {
                        return Chip(
                          label: Text(user.email),
                          onDeleted: () {
                            setState(() {
                              users.remove(user);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<UserModel>(
                      hint: const Text('Selecione um usuário'),
                      value: _selectedUser,
                      items: usersData.map((user) {
                        return DropdownMenuItem<UserModel>(
                          value: user,
                          child: Text(user.email),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUser = value;
                          if (value != null && !users.contains(value)) {
                            users.add(value);
                          }
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text;
                final message = _messageController.text;

                if (title.isNotEmpty &&
                    message.isNotEmpty &&
                    users.isNotEmpty) {
                  final (succes, error) = await SendNotificationUsecase.call(
                    title,
                    message,
                    users.map((u) => u.id).toList(),
                  );
                  if (error != null || succes == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor:
                            Theme.of(context).colorScheme.errorContainer,
                        content: Center(child: Text(error!)),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: Text(succes)),
                      ),
                    );
                    //context.pop(context);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor:
                          Theme.of(context).colorScheme.errorContainer,
                      content: const Center(
                        child: Text(
                          'Preencha todos os campos e garanta que pelo menos 1 usuário esteja selecionado.',
                        ),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Enviar Notificação'),
            ),
          ],
        ),
      ),
    );
  }
}
