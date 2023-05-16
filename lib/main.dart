import 'package:flutter/material.dart';
import 'package:sqlite_example/database_operation.dart';

import 'home_page.dart';

//https://docs.flutter.dev/cookbook/persistence/sqlite
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final operations = Operations.db;
  await operations.createDb();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Home Page'),
    );
  }
}
