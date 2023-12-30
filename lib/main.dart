
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lift_sync/firebase_options.dart';
import 'package:lift_sync/pages/first_screen.dart';


void main() async {
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
      title: 'LiftSync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyFirstPage(title: 'LiftSync'),
    );
  }
}
