import 'package:flutter/material.dart';
import 'signup.dart';
import '../main.dart';
import 'dart:ui';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'phoneVerification.dart';
import 'phoneRegister.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/gestures.dart';

void main() {
  runApp(const Login());
}

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

// 2. The State Class (The "Brain")
class _LoginState extends State<Login> {
   final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscurePassword = true; // Start with the password hidden
  final emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom; //to get keyboards size
    return Scaffold(

        resizeToAvoidBottomInset: false, // Prevents the background from squashing
        extendBodyBehindAppBar: true, // This allows the gradient to go behind the bar
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Makes it clear
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 176, 39, 119), size:35),
            onPressed: () {
              // This removes the Login screen and goes back
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        ),
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

          child:
            Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 65),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.9,

                    // Use mainAxisSize: MainAxisSize.min if you want the glass to hug the content
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.1),
                        width: 2.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.1,
                          ), // Keep it very subtle
                          blurRadius: 30, // How much the shadow spreads
                          offset: const Offset(
                            10,
                            10,
                          ), // Moves shadow down and right
                          spreadRadius:
                          -5, // Pulls shadow in slightly for a cleaner look
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        // We only allow scrolling when the keyboard is actually up
                        physics: keyboardHeight > 0
                            ? const BouncingScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                      child: Column(
                      mainAxisSize:
                      MainAxisSize.min, // Glass box shrinks to fit
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'MyDancingScript',
                            fontSize: 70,
                            color: const Color.fromARGB(255, 176, 39, 119),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Image.asset(
                          'assets/logincat.gif',
                          height: 120,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Login to your account:',
                          style: TextStyle(
                            fontFamily: 'MyCaveat',
                            fontSize: 26,
                            color: const Color.fromARGB(255, 176, 39, 119),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        //text fields. using another method to reduce work
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              _buildTextField(
                                label: "Email",
                                icon: Icons.email_outlined,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                label: "Password",
                                icon: Icons.lock_outline,
                                isPassword: true,
                              ),
                              const SizedBox(height: 45),
                            ],
                          ),
                        ),

                        //signup button
                        FractionallySizedBox(
                          widthFactor:
                          0.8, //80% of the white background elevated screen
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              elevation: 8,
                              shadowColor: const Color.fromARGB(
                                255,
                                91,
                                80,
                                94,
                              ),
                              minimumSize: Size(350, 55),
                              backgroundColor: const Color.fromARGB(
                                  255, 250, 234, 243
                              ),
                              side: BorderSide(
                                color: const Color.fromARGB(255, 176, 39, 119),
                                width: 2,
                              ), // The border color,
                              foregroundColor: const Color.fromARGB(
                                255,
                                53,
                                1,
                                24,
                              ), // This changes the Icon and Text color // Width: 200, Height: 60
                            ),
                            onPressed: () {
                              _submit();
                            },
                            icon: Icon(Icons.assignment, size: 30),
                            label: Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'MyDancingScript',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),
                        //change to login page
                        //row to keep it in one line
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?",
                              style: TextStyle(
                                fontSize: 15,
                              ),),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Signup()),
                                );
                              },
                              child: const Text(
                                "Sign-up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 176, 39, 119),
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],

                        ),
                        //change to phone register page page
                        //row to keep it in one line
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Log in with phone number?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PhoneRegister()),
                                );
                              },
                              child: const Text(
                                "Phone Log-in",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 176, 39, 119),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: keyboardHeight > 0 ? (keyboardHeight - 50).clamp(0.0, double.infinity) : 20), //for the scrolling
                      ],
                    ),
                    ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
        obscureText: isPassword ? _obscurePassword : false,

      autovalidateMode: AutovalidateMode.onUserInteraction, // Shows error after they start typing
      validator: (value) {
        ///to check it isnt empty
        if (isPassword) {
          if (value!.isEmpty) {
            return 'please enter password';
          }
          else {
            return null;
          }
        }
        else {
          if (value!.isEmpty) {
            return 'please enter email';
          }
          else if (!emailRegExp.hasMatch(value)) {
            return 'please enter correct email';
          }
          else {
            return null;
          }
        }
      },

      //for saving the values in variables
      onSaved: (value) {
        if (isPassword) {
          _password = value!;
        } else {
          _email = value!;
        }
      },

      decoration: InputDecoration(

        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 176, 39, 119)),
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 176, 39, 119)),
        filled: true,
        fillColor: Colors.white.withValues(
          alpha: 0.5,
        ), // Semi-transparent white
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 176, 39, 119),
            width: 2,
          ),
        ),
        // 2. Add the toggle button ONLY if it's a password field
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: const Color.fromARGB(255, 176, 39, 119),
          ),
          onPressed: () {
            // 3. This tells Flutter to rebuild the UI with the new value
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        )
            : null, // No icon for the email field

      ),
    );
  }


   Future<void> _submit() async {
     if (!_formKey.currentState!.validate()) return;
     _formKey.currentState!.save();

     try {
       await FirebaseAuth.instance.signInWithEmailAndPassword(
         email: _email,
         password: _password,
       );

       if (!mounted) return;
       // Navigate to your home/dashboard page after successful login
       Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context) => const PhoneRegister()),
       );
     } on FirebaseAuthException catch (e) {
       if (!mounted) return;
       String message;
       switch (e.code) {
         case 'user-not-found':
         case 'wrong-password':
         case 'invalid-credential':
           message = 'Invalid email or password.';
           break;
         case 'user-disabled':
           message = 'This account has been disabled.';
           break;
         case 'too-many-requests':
           message = 'Too many attempts. Try again later.';
           break;
         default:
           message = e.message ?? 'Login failed.';
       }

       showDialog(
         context: context,
         builder: (context) => AlertDialog(
           title: const Text('Login Failed'),
           content: Text(message),
           actions: [
             TextButton(
               onPressed: () => Navigator.of(context).pop(),
               child: const Text('OK'),
             ),
           ],
         ),
       );
     }
   }
}
