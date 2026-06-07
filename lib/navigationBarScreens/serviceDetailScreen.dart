import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String serviceName;
  final IconData serviceIcon;

  const ServiceDetailScreen({
    super.key,
    required this.serviceName,
    required this.serviceIcon,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color.fromARGB(255, 176, 39, 119);

    return Scaffold(
      backgroundColor: Colors.transparent,
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
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        size: 32, color: accent),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(serviceIcon, size: 120, color: accent),
                      const SizedBox(height: 20),
                      Text(
                        serviceName,
                        style: const TextStyle(
                          fontFamily: 'MyDancingScript',
                          fontSize: 65,
                          color: accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}