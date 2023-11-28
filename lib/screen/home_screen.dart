import 'package:flutter/material.dart';
import 'package:hackerton/widgets/BottomNavi.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0x000fffff),
        title: Image.asset(
          'assets/images/assembly.png',
          fit: BoxFit.cover,
          width: 77,
          height: 53,
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarExample(),
    );
  }
}
