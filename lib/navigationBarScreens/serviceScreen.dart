import 'package:flutter/material.dart';
import '../navigationBarScreens/serviceDetailScreen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final List<String> options = [
    'Music', 'Videos', 'Photos', 'Documents',
    'attempt 5', 'attempt 6', 'attempt 7',
  ];
  final List<IconData> icons = [
    Icons.music_note,
    Icons.movie,
    Icons.photo,
    Icons.description,
    Icons.description,
    Icons.description,
    Icons.description,
  ];
  int? _selectedIndex;

  void _goToDetail() {
    if (_selectedIndex == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServiceDetailScreen(
          serviceName: options[_selectedIndex!],
          serviceIcon: icons[_selectedIndex!],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 52),
            Text(
              'Choose your service',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'MyDancingScript',
                fontSize: 65,
                color: const Color.fromARGB(255, 176, 39, 119),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: options.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndex == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromARGB(255, 253, 218, 238)
                            : const Color.fromARGB(255, 236, 247, 253),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(4, 6),
                          ),
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(-3, -3),
                          ),
                        ],
                        border: Border.all(
                          color: isSelected
                              ? const Color.fromARGB(255, 176, 39, 119)
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icons[index], size: 40),
                          Text(
                            options[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 90), // leaves room for the floating button
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: AnimatedOpacity(
            opacity: _selectedIndex == null ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: _selectedIndex == null,
              child: FloatingActionButton(
                onPressed: _goToDetail,
                backgroundColor: const Color.fromARGB(255, 176, 39, 119),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}