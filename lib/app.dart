import 'package:flutter/material.dart';
import 'app_router.dart';

class BeesyApp extends StatelessWidget {
  const BeesyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      routerConfig: router,
    );
  }
}
