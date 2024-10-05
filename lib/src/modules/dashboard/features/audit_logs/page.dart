import 'package:app/src/modules/dashboard/features/audit_logs/usecase.dart';
import 'package:flutter/material.dart';

class AuditLogsPage extends StatelessWidget {
  const AuditLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logs"),
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: AuditLogsUsecase.call(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            return Text(snapshot.data.toString());
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )),
    );
  }
}
