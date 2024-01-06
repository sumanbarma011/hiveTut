import 'package:database/home.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

// import 'dart:async';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
 await Hive.openBox('shopping_box');


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }
}