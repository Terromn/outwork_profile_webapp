import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:outwork_mx_profile_webapp/assets/app_theme.dart';
import 'package:outwork_mx_profile_webapp/firebase_options.dart';

import 'screens/auth/auth_widget_tree.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Outwork App',
      theme: TeAppThemeData.darkTheme,
      home: const AuthWidgetTree(),
    );
  }
}
