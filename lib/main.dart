import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:incog/firebase_options.dart';
import 'package:incog/signup_page.dart';
import 'package:incog/splash_screen.dart';


import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}







class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anonymous Chat',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        hintColor: Colors.tealAccent,
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
