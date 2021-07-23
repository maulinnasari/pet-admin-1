import 'package:flutter/material.dart';
import 'package:flutterfirebaseauth/splash.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //ditambahkan agar dapat menjalankan syntax sebelum Myapp
  await Firebase.initializeApp(); //await : bersifat future
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Center',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LauncherPage(),
    );
  }
}
