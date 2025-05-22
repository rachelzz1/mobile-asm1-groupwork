import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/home_page.dart';
//test pxy

void main() async {
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
      home: const FitnessHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
