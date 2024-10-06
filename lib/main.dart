import 'package:app/app.dart';
import 'package:app/getit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/modules/auth/utils/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  getIt.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );

  await UserAuthUtils(getIt.get<SharedPreferences>()).restoreUser();

  runApp(const BeesyApp());
}
