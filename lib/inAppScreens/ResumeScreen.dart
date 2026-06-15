import 'package:flutter/material.dart';
import '../openingPages/signup.dart';
import '../main.dart';
import 'dart:ui';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../openingPages/phoneVerification.dart';
import '../openingPages/phoneRegister.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessary for async main
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Wakes up Firebase
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
  final List<String> files = ['Resume1.pdf', 'Resume2.pdf', 'Resume3.pdf'];
  //// FOR THE MOCK

  late List<DownloadState> _states; ///to track the state of the file
  @override
  void initState() {
    super.initState();
    _states = List.filled(files.length, DownloadState.notDownloaded);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false, // Prevents the background from squashing
        extendBodyBehindAppBar: true, // Lets the gradient go behind the AppBar
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 250, 208, 216),
          title: const Text(
            'Resume',
            style: TextStyle(
              fontFamily: 'MyDancingScript',
              fontSize: 35,
              color: Color.fromARGB(255, 74, 7, 46),
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

          /// SafeArea keeps the buttons away from system gesture bars at the bottom
          /// of the phone. top: false because the AppBar already covers the top.
          child: SafeArea(
            top: false,

            /// Column = vertical layout. The Expanded child eats all the leftover
            /// space; the button row takes only what it needs. That's why the
            /// buttons stay put when the list above scrolls — they're NOT inside
            /// the ListView, they're siblings to it in the Column.
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: files.length,            // how many rows total
                    itemBuilder: (context, index) {    // how to build row #index
                      return Card( ///card for the splitting- to see each file separately
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          minVerticalPadding: 24, ///padding to have the card a certain size
                          leading: _fileIcon(files[index]),
                          title: Text(files[index]),
                        ),
                      );
                    },
                  ),
                ),

                /// ─── Bottom button row ───
                /// Lives outside the ListView, so scrolling the list doesn't move it.
                /// Each button is wrapped in Expanded so they share the row width 50/50.
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            elevation: 8,
                            shadowColor: const Color.fromARGB(255, 91, 80, 94),
                            minimumSize: const Size(0, 55), // height = 55; width handled by Expanded
                            backgroundColor: const Color.fromARGB(255, 250, 234, 243),
                            side: const BorderSide(
                              color: Color.fromARGB(255, 176, 39, 119),
                              width: 2,
                            ),
                            foregroundColor: const Color.fromARGB(255, 53, 1, 24),
                          ),
                          onPressed: () {
                            //action for button 1
                          },
                          icon: const Icon(Icons.add_link, size: 20),
                          label: const Text(
                            'Upload from link',
                            style: TextStyle(
                              fontFamily: 'MyCaveat',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            elevation: 8,
                            shadowColor: const Color.fromARGB(255, 91, 80, 94),
                            minimumSize: const Size(0, 55),
                            backgroundColor: const Color.fromARGB(255, 250, 234, 243),
                            side: const BorderSide(
                              color: Color.fromARGB(255, 176, 39, 119),
                              width: 2,
                            ),
                            foregroundColor: const Color.fromARGB(255, 53, 1, 24),
                          ),
                          onPressed: () {
                            // action for button 2
                          },
                          icon: const Icon(Icons.devices, size: 18),
                          label: const Text(
                            'Upload from device',
                            style: TextStyle(
                              fontFamily: 'MyCaveat',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Picks an icon + color based on the file extension.
  Widget _fileIcon(String filename) {
    final ext = filename.split('.').last.toLowerCase(); ////taking the finale of the filename
    IconData icon = Icons.insert_drive_file; ///default value
    Color color = Colors.grey;

    if (ext == 'pdf') { ///pdf file
      icon = Icons.picture_as_pdf;
      color = const Color.fromARGB(255, 218, 165, 175);
    } else if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) { ///picture file
      icon = Icons.image;
      color = const Color.fromARGB(255, 167, 204, 220);
    } else if (['mp4', 'mov', 'avi', 'mkv'].contains(ext)) { ///video file
      icon = Icons.movie;
      color = const Color.fromARGB(255, 173, 227, 202);
    } else if (['mp3', 'wav', 'm4a'].contains(ext)) { ///sound file
      icon = Icons.audiotrack;
      color = const Color.fromARGB(255, 234, 211, 176);
    } else if (['doc', 'docx'].contains(ext)) { ///word file
      icon = Icons.description;
      color = const Color.fromARGB(255, 251, 189, 201);
    } else if (['xls', 'xlsx', 'csv'].contains(ext)) { ///excel file
      icon = Icons.table_chart;
      color = const Color.fromARGB(255, 199, 184, 237);
    } else if (ext == 'txt') { ///txt file
      icon = Icons.text_snippet;
      color = const Color.fromARGB(255, 170, 205, 160);
    } else if (['zip', 'rar', '7z'].contains(ext)) { ///zip file
      icon = Icons.folder_zip;
      color = const Color.fromARGB(255, 193, 147, 184);
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

  /// Future is Dart's way of representing a value that doesn't exist yet but will eventually.
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
}