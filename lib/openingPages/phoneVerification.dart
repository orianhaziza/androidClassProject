import 'package:flutter/material.dart';
import 'signup.dart';
import '../main.dart';
import 'phoneRegister.dart';
import 'dart:ui';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/gestures.dart';


class PhoneVerification extends StatefulWidget {
  final String verificationId;
  const PhoneVerification({super.key, required this.verificationId});
  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

// 2. The State Class (The "Brain")
class _PhoneVerificationState extends State<PhoneVerification> {
  final _formKey = GlobalKey<FormState>();
  //for the code verification
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());


  @override
  void dispose() {
    // Always clean up controllers and nodes to prevent memory leaks
    for (var controller in _controllers) {controller.dispose();}
    for (var node in _focusNodes) {node.dispose();}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom; //to get keyboards size
    return Scaffold(

        resizeToAvoidBottomInset: false, // Prevents the background from squashing
        extendBodyBehindAppBar: true, // This allows the gradient to go behind the bar
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent, // Makes it clear
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 176, 39, 119), size:35),
        //     onPressed: () {
        //       // This removes the Login screen and goes back
        //       if (Navigator.canPop(context)) {
        //         Navigator.pop(context);
        //       }
        //     },
        //   ),
        // ),
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
                              'Enter the password you received:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'MyCaveat',
                                fontSize: 30,
                                color: const Color.fromARGB(255, 176, 39, 119),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 25),
                            //text fields. using another method to reduce work
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(6, (index) => _otpBox(index)),
                              ),
                            ),
                            const SizedBox(height: 35),
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
                                  _verifyCode();
                                },
                                icon: Icon(Icons.app_shortcut_outlined, size: 30),
                                label: Text(
                                  'Verify phone number',
                                  style: TextStyle(
                                    fontFamily: 'MyDancingScript',
                                    fontSize: 25,
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
                                      MaterialPageRoute(builder: (context) => const PhoneRegister()),
                                    );
                                  },
                                  child: const Text(
                                    "Edit number",
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





  Widget _otpBox(int index) {
    return Container(
      height: 60,
      width: 45,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            _focusNodes[index + 1].requestFocus(); // Move forward
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus(); // Move backward on delete
          }
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB( 255,
          53,
          1,
          24,)),
        decoration: const InputDecoration(
          counterText: "", // Hides the character count
          border: InputBorder.none,
        ),
      ),
    );
  }


  Future<void> _verifyCode() async {
    final String smsCode = _controllers.map((c) => c.text).join();
    if (smsCode.length != 6) return;

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,   // ← from the widget
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;
      // TODO: navigate to your post-login home
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Wrong Code'),
          content: Text(e.message ?? 'Invalid code'),
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
