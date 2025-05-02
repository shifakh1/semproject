import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';

//testing commit

Future<void> main() async {
  // STEP 1: Initialize binding FIRST
  WidgetsFlutterBinding.ensureInitialized();

  // STEP 2: Then initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // STEP 3: Finally run your app
  runApp(MyApp());
}

class WidegtsFlutterBinding {
  static void ensureInitialized() {}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lahore Lahore Aye',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SplashScreen(),
    );
  }
}