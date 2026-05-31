import 'package:flutter/material.dart';
import 'openingPages/signup.dart';
import 'openingPages/login.dart';
import 'openingPages/phoneVerification.dart';
import 'openingPages/phoneRegister.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessary for async main
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);            // Wakes up Firebase
  runApp(const MainApp());
}

// 1. The "Base Station" (Container)
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(), // Points to our UI widget below
    );
  }
}

// 2. The Actual UI (The Page)
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Text('Welcome!',
                  style: TextStyle(fontFamily: 'MyDancingScript', fontSize: 70, color: Color.fromARGB(255, 176, 39, 119), fontWeight: FontWeight.bold)),
              const Text('Please login or signup',
                  style: TextStyle(fontFamily: 'MyCaveat', fontSize: 34, color: Color.fromARGB(255, 176, 39, 119), fontWeight: FontWeight.bold)),

              const SizedBox(height: 30),
              Image.asset('assets/welcomecat.jpg', height: 250),
              const SizedBox(height: 70),

              // --- LOGIN BUTTON ---
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  elevation: 8,
                  shadowColor: const Color.fromARGB(255, 91, 80, 94),
                  backgroundColor: const Color.fromARGB(255, 245, 229, 238),
                  side: const BorderSide(color: Color.fromARGB(255, 176, 39, 119), width: 2),
                  minimumSize: const Size(350, 55),
                  foregroundColor: const Color.fromARGB(
                    255,
                    53,
                    1,
                    24,
                  ), //the color of the button and icon
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                icon: const Icon(Icons.auto_awesome, size: 30),
                label: const Text('Login', style: TextStyle(fontFamily: 'MyDancingScript', fontSize: 32, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 30),

              // SIGNUP BUTTON
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  elevation: 8,
                  shadowColor: const Color.fromARGB(255, 91, 80, 94),
                  backgroundColor: const Color.fromARGB(255, 243, 229, 245),
                  side: const BorderSide(color: Color.fromARGB(255, 176, 39, 119), width: 2),
                  minimumSize: const Size(350, 55),
                  foregroundColor: const Color.fromARGB(
                    255,
                    53,
                    1,
                    24,
                  ), //the color of the button and icon
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Signup()),
                  );
                },

                icon: const Icon(Icons.assignment, size: 30),
                label: const Text('Sign-Up',
                    style: TextStyle(fontFamily: 'MyDancingScript', fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}