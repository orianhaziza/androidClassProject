import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Settings',
        style: TextStyle(
          fontFamily: 'MyDancingScript',
          fontSize: 65,
          color: const Color.fromARGB(255, 176, 39, 119),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}