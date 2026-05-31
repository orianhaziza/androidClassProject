import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        const SizedBox(height: 70),
       Text(
        'Profile',
        style: TextStyle(
          fontFamily: 'MyDancingScript',
          fontSize: 65,
          color: const Color.fromARGB(255, 176, 39, 119),
          fontWeight: FontWeight.bold,
        ),
      ),
        const SizedBox(height: 30),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(
              'assets/logincat.gif',
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Orian Haziza',
            style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold,fontFamily: 'MyCaveat'),
          ),
          Text(
            'Student',
            style: TextStyle(fontSize: 30, color: Colors.grey,fontFamily: 'MyCaveat'),
          ),
          SizedBox(height: 20),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 20),
              Text(
                'Email:',
                style: TextStyle(fontSize: 30, color: Colors.black,fontFamily: 'MyCaveat'),
              ),
              const SizedBox(width: 20),
              Text(
                'orian.haziza@e.braude.ac.il',
                style: TextStyle(fontSize: 30, color: Colors.black,fontFamily: 'MyCaveat'),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 20),
              Text(
                'Date Of Birth:',
                style: TextStyle(fontSize: 25, color: Colors.black,fontFamily: 'MyCaveat'),
              ),
              const SizedBox(width: 20),
              Text(
                'Oct. 5th, 2000',
                style: TextStyle(fontSize: 25, color: Colors.black,fontFamily: 'MyCaveat'),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 17),
              Text(
                'Linkdin:',
                style: TextStyle(fontSize: 28, color: Colors.black,fontFamily: 'MyCaveat'),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: _openLinkedIn,
                icon: const Icon(Icons.link),
                label: const Text('LinkedIn'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF89D2D5),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    );
  }


  Future<void> _openLinkedIn() async {
    final url = Uri.parse('https://www.linkedin.com/in/orianhaziza');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch LinkedIn');
    }
  }
}