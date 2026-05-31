import 'package:flutter/material.dart';
import 'signup.dart';
import '../main.dart';
import 'phoneVerification.dart';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';
//import 'package:flutter/gestures.dart';


class PhoneRegister extends StatefulWidget {
  const PhoneRegister({super.key});
  @override
  State<PhoneRegister> createState() => _PhoneRegisterState();
}

// 2. The State Class (The "Brain")
class _PhoneRegisterState extends State<PhoneRegister> {
  final _formKey = GlobalKey<FormState>();
  String _phone = '';
  final phoneRegExp = RegExp(r'^[0-9]{10}$');
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                          const SizedBox(height: 50),
                          Text(
                            'Phone Verification',
                            style: TextStyle(
                              fontFamily: 'MyDancingScript',
                              fontSize: 50,
                              color: const Color.fromARGB(255, 176, 39, 119),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //const SizedBox(height: 3),
                          Image.asset(
                            'assets/phonereg.gif',
                            height: 180,
                            width: 160,
                            fit: BoxFit.cover,
                          ),
                          //const SizedBox(height: 5),
                          Text(
                            'Register your phone before\n getting started:',
                            textAlign: TextAlign.center,
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
                                  label: "Phone",
                                  icon: Icons.local_phone_outlined ,
                                ),
                                const SizedBox(height: 25),
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
                                _submit(context);
                              },
                              icon: Icon(Icons.app_shortcut_outlined, size: 30),
                              label: Text(
                                'Send me a code',
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
                              const Text("Change method?",
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
                                  "Sign-up with email",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 176, 39, 119),
                                    fontSize: 17,
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
  }) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      autovalidateMode: AutovalidateMode.onUserInteraction, // Shows error after they start typing
      validator: (value) {
        ///to check it isnt empty

          if (value!.isEmpty) {
            return 'please enter phone number';
          }
          else if (!phoneRegExp.hasMatch(value)) {
            return 'please enter correct number';
          }
          else {
            return null;
          }
      },

      //for saving the values in variables
      onSaved: (value) {
          _phone = value!;
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
      ),
    );
  }


  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // Convert 0501234567 → +972501234567 (Firebase needs E.164 format)
    final String formattedPhone = '+972${_phone.substring(1)}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await _auth.verifyPhoneNumber(
      phoneNumber: formattedPhone,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        // Android auto-retrieval (rare). Sign in directly.
        await _auth.signInWithCredential(credential);
        if (!mounted) return;
        Navigator.of(context).pop(); // close loader
      },

      verificationFailed: (FirebaseAuthException e) {
        if (!mounted) return;
        Navigator.of(context).pop(); // close loader
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Verification Failed'),
            content: Text(e.message ?? 'Unknown error'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },

      codeSent: (String verificationId, int? resendToken) {
        if (!mounted) return;
        Navigator.of(context).pop(); // close loader
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PhoneVerification(
              verificationId: verificationId,
            ),
          ),
        );
      },

      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }


}
