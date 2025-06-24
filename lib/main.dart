import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
//import 'screens/home_page.dart';
import 'screens/welcome_screen.dart'; 
import 'package:firebase_core/firebase_core.dart'; // 确保已导入
import 'package:cloud_firestore/cloud_firestore.dart';
//test pxy

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 必须加这句
  await Firebase.initializeApp();            // 初始化 Firebase
  await GetStorage.init();
  final box = GetStorage();
  box.write('isDone', false);
  box.write('isGo', false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SansSerif',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.orangeAccent,
          primary: Colors.blue,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: const WelcomeScreen(), // 使用 WelcomeScreen 作为首页
      debugShowCheckedModeBanner: false,
    );
  }
}
