
import 'package:attend_mobile/presentation/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Attendance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
      builder: EasyLoading.init(),
    );
  }
}

