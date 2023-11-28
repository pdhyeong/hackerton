import 'package:flutter/material.dart';
import 'GptService.dart';
import 'package:hackerton/dart_server.dart';
import 'package:hackerton/widgets/BottomNavi.dart';
import 'package:hackerton/screen/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}