import 'package:flutter/material.dart';
import 'login.dart';
import '../main.dart';
import 'dart:ui';
import 'phoneVerification.dart';
import 'phoneRegister.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/gestures.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

// 2. The State Class (The "Brain")
class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _username= '';
  String _password = '';
  bool _obscurePassword = true; // Start with the password hidden
  bool _obscureConfirmPassword = true;
  final TextEditingController _passwordController = TextEditingController();
  final emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  //password must contain at least 1 char, 1 digit, and len>=4
  final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{6,}$');

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right:20, top: 68, bottom: 20),
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
                        Text(
                          'Sign-up',
                          style: TextStyle(
                            fontFamily: 'MyDancingScript',
                            fontSize: 70,
                            color: const Color.fromARGB(255, 176, 39, 119),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Image.asset(
                          'assets/typingcat.gif',
                          height: 90,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Please fill in your details:',
                          style: TextStyle(
                            fontFamily: 'MyCaveat',
                            fontSize: 26,
                            color: const Color.fromARGB(255, 176, 39, 119),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        //text fields. using another method to reduce work
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            children: [
                              _buildTextField(
                                label: "Username",
                                icon: Icons.person_outline,
                                type:'username',
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                label: "Email",
                                icon: Icons.email_outlined,
                                type: 'email',
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                label: "Password",
                                icon: Icons.lock_outline,
                                type: 'password',
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                label: "Confirm Password",
                                icon: Icons.lock_reset_outlined,
                                type: 'confirm',
                              ),
                              const SizedBox(height: 35),
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
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                // Call the Firebase registration function
                                await _registerUser();
                              }
                            },
                            icon: Icon(Icons.assignment, size: 30),
                            label: Text(
                              'Sign-Up',
                              style: TextStyle(
                                fontFamily: 'MyDancingScript',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),
                        //change to login page
                        //row to keep it in one line
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already signed up?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Login()),
                                );
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 176, 39, 119),
                                  fontSize: 15,
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
                            const Text("Sign up with phone number?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PhoneRegister()),
                                );
                              },
                              child: const Text(
                                "Phone Register",
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



///HELPER METHOD for text fields
  Widget _buildTextField({
    required String label,
    required IconData icon,
    String type = 'text', // Options: 'email', 'username', 'password', 'confirm'
  }) {
    bool isAnyPassword = (type == 'password' || type == 'confirm');
    return TextFormField(
      controller: type == 'password' ? _passwordController : null,
      obscureText:type == 'password'
          ? _obscurePassword
          : (type == 'confirm' ? _obscureConfirmPassword : false),
      autovalidateMode: AutovalidateMode.onUserInteraction, // Shows error after they start typing

      //for live updates of the password
      onChanged: (value) {
        if (type == 'password') {
          _password = value;
        }
      },

      validator: (value) {
        ///to check it isnt empty
        if (value == null || value.isEmpty) return 'Field cannot be empty';

        if (type == 'email' && !emailRegExp.hasMatch(value)) {
          return 'Enter a valid email';
        }

        if (type == 'username' && value.length < 3) {
          return 'Username must be longer than 3 characters';
        }

        if (type == 'password' && !passwordRegExp.hasMatch(value))
          {
            return 'Must have 6+ characters- 1 letter & 1 number';
          }

        if (type == 'confirm' && value !=_passwordController.text) {
          return 'Passwords do not match';
        }

        return null;
      },



      //for saving the values in variables
      onSaved: (value) {
        if (type == 'email') _email = value!;
        if (type == 'username') _username = value!;
        if (type == 'password') _password = value!;
        // We usually don't need to save 'confirm' since it's just for checking
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
        suffixIcon: isAnyPassword
            ? IconButton(
          icon: Icon(
            // 2. Check type for the icon
            (type == 'password' ? _obscurePassword : _obscureConfirmPassword)
                ? Icons.visibility_off
                : Icons.visibility,
            color: const Color.fromARGB(255, 176, 39, 119),
          ),
          onPressed: () {
            // 3. This tells Flutter to rebuild the UI with the new value
            setState(() {
              if(type=='password') {
                _obscurePassword = !_obscurePassword;
              }
              else if (type=='confirm')
                {
                  _obscureConfirmPassword= !_obscureConfirmPassword;
                }
            });
          },
        )
            : null, // No icon for the email field

      ),
    );
  }


  Future<void> _registerUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // Success logic: Take them to the next screen
      if (mounted) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const PhoneRegister()),
        // );
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Registered successfully!'),
            content: Text('Thank you for joining us :)'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = e.message ?? "An unknown error occurred.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),);
    }
  }
}
