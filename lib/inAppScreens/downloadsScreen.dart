import 'package:flutter/material.dart';
import '../openingPages/signup.dart';
import '../main.dart';
import 'dart:ui';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../openingPages/phoneVerification.dart';
import '../openingPages/phoneRegister.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/gestures.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Necessary for async main
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);            // Wakes up Firebase
  runApp(const DownloadsScreen());
}

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});
  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}


enum DownloadState { notDownloaded, loading, downloaded } ///for the file's state

// 2. The State Class (The "Brain")
class _DownloadsScreenState extends State<DownloadsScreen> {
  final List<String> files = ['Report.pdf', 'Photo.mp3', 'Notes.zip', 'Video.txt','Report1.pdf', 'Photo1.jpg', 'Notes1.txt', 'Video1.mp4','Report2.pdf', 'Photo2.jpg', 'Notes2.txt', 'Video2.mp4'];
  ////FOR THE MOCK

  late List<DownloadState> _states; ///to track the state of the file
  @override
  void initState() {
    super.initState();
    _states = List.filled(files.length, DownloadState.notDownloaded);
  }



  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom; //to get keyboards size
    return MaterialApp(
        home:Scaffold(

      resizeToAvoidBottomInset: false, // Prevents the background from squashing
      extendBodyBehindAppBar: true, // This allows the gradient to go behind the bar
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 208, 216),
        title: const Text(
          'Download item',
          style: TextStyle(
            fontFamily: 'MyDancingScript',
            fontSize: 35,
            color: const Color.fromARGB(255, 74, 7, 46),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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


          child: ListView.builder(
              itemCount: files.length,           // how many rows total
              itemBuilder: (context, index) { // how to build row #index
                return Card( ///card for the splitting- to see each file separately
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child:ListTile(
                      leading:  _fileIcon(files[index]),
                  title: Text(files[index]),
                  subtitle: const Text('Tap to download'),
                  // trailing: TextButton(
                  //   onPressed: () {
                  //     // download logic here
                  //   },
                  //   style: TextButton.styleFrom(
                  //     backgroundColor: Colors.lightBlue.shade50,
                  //     foregroundColor: Colors.blue,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //   ),
                  //   child: const Text('GET'),
                  // ),
                      trailing: _trailingButton(index),
                    ),
                );
              }
          )

          ),
        ),
    );
  }



  Widget _fileIcon(String filename) {
    final ext = filename.split('.').last.toLowerCase(); ////taking the finale of the filename
    IconData icon = Icons.insert_drive_file; ///default value
    Color color = Colors.grey;

    if (ext == 'pdf') { ///pdf file
      icon = Icons.picture_as_pdf;
      color = Color.fromARGB(255, 218, 165, 175);
    } else if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) { ///picture file
      icon = Icons.image;
      color = Color.fromARGB(255, 167, 204, 220);
    } else if (['mp4', 'mov', 'avi', 'mkv'].contains(ext)) { ///video file
      icon = Icons.movie;
      color = Color.fromARGB(255, 173, 227, 202);
    } else if (['mp3', 'wav', 'm4a'].contains(ext)) { ///sound file
      icon = Icons.audiotrack;
      color = Color.fromARGB(255, 234, 211, 176);
    } else if (['doc', 'docx'].contains(ext)) { ///word file
      icon = Icons.description;
      color = Color.fromARGB(255, 251, 189, 201);
    } else if (['xls', 'xlsx', 'csv'].contains(ext)) { ///excel file
      icon = Icons.table_chart;
      color =Color.fromARGB(255, 199, 184, 237);
    } else if (ext == 'txt') { ///txt file
      icon = Icons.text_snippet;
      color = Color.fromARGB(255, 170, 205, 160);
    } else if (['zip', 'rar', '7z'].contains(ext)) { ///zip file
      icon = Icons.folder_zip;
      color = Color.fromARGB(255, 193, 147, 184);
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }



///Future is Dart's way of representing a value that doesn't exist yet but will eventually
  ///
  Future<void> _download(int index) async {
    setState(() {
      _states[index] = DownloadState.loading;
    });

    await Future.delayed(const Duration(seconds: 2)); // fake download

    if (!mounted) return;
    setState(() {
      _states[index] = DownloadState.downloaded;
    });
  }


  Widget _trailingButton(int index) {
    final state = _states[index];

    if (state == DownloadState.loading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final isDone = state == DownloadState.downloaded;
    return TextButton(
      onPressed: isDone
          ? () { /* open file logic later */ }
          : () => _download(index),
      style: TextButton.styleFrom(
        backgroundColor: Colors.lightBlue.shade50,
        foregroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(isDone ? 'OPEN' : 'GET'),
    );
  }



}
