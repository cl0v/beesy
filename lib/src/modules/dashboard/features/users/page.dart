
import 'package:app/src/modules/auth/data/models/user.dart';
import 'package:app/src/modules/dashboard/features/users/data/usecases/fetch_users.dart';
import 'package:flutter/material.dart';

import 'data/usecases/update_user_role.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de usuários"),
      ),
      body: SafeArea(
          child: FutureBuilder<List<UserModel>>(
        future: FetchUsersUsecase.call(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            if (users.isEmpty) {
              return const Center(
                child: Text("Nenhum usuário encontrado"),
              );
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Alterar permissão",
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Cancelar"),
                              ),
                            ],
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: UserRole.values.map((role) {
                                  if (role == user.role) {
                                    return const SizedBox();
                                  }
                                  return ListTile(
                                    onTap: () async {
                                      final (newRole, error) =
                                          await UpdateUserRoleUsecase.call(
                                              role, user.id);
                                      if (error != null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(error),
                                          ),
                                        );
                                      } else if (newRole != null) {
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      }
                                    },
                                    title: Text(role.toString().split(".")[1]),
                                  );
                                }).toList()),
                          );
                        });
                  },
                  title: Text(user.email),
                  subtitle: Text(
                    user.role.toString(),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )),
    );
  }
}
