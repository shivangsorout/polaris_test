import 'package:flutter/material.dart';
import 'package:polaris_test/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polaris Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[100],
          elevation: 10,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const HomeView(),
    );
  }
}
