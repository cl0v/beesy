import 'package:app/app.dart';
import 'package:app/getit.dart';
import 'package:app/src/fcm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/modules/auth/utils/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupFirebaseMessagingHandler();

  getIt.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );

  await UserAuthUtils(getIt.get<SharedPreferences>()).restoreUser();

  runApp(const BeesyApp());
}
