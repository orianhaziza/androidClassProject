import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../navigationBarScreens/serviceScreen.dart';
import '../navigationBarScreens/profileScreen.dart';
import '../navigationBarScreens/settingsScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const navigationBarLogic());
}

class navigationBarLogic extends StatefulWidget {
  const navigationBarLogic({super.key});

  @override
  State<navigationBarLogic> createState() => _navigationBarLogicState();
}

class _navigationBarLogicState extends State<navigationBarLogic> {
  int _currentIndex = 1; // start on Home (middle)

  final List<Widget> _screens = const [
    ProfileScreen(),
    ServiceScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 193, 230, 247),
                Color.fromARGB(255, 244, 231, 192),
                Color.fromARGB(255, 218, 165, 175),
              ],
              stops: [0.0, 0.4, 0.9],
            ),
          ),
          child: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color.fromARGB(255, 250, 208, 216),
          selectedItemColor: const Color.fromARGB(255, 136, 2, 89),
          unselectedItemColor: const Color.fromARGB(255, 84, 117, 122),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          iconSize: 32,
          selectedFontSize: 16,
          unselectedFontSize: 14,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}