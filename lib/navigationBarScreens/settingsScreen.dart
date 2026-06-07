import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;
  bool _darkMode = false;
  bool _sound = false;

  @override
  Widget build(BuildContext context) {
    const accent = Color.fromARGB(255, 176, 39, 119);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'MyDancingScript',
                fontSize: 65,
                color: accent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _toggleRow(
              label: _notifications ? 'Notifications: On' : 'Notifications: Off',
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
              accent: accent,
            ),
            const SizedBox(height: 16),
            _toggleRow(
              label: _darkMode ? 'Dark Mode: Enabled' : 'Dark Mode: Disabled',
              value: _darkMode,
              onChanged: (v) => setState(() => _darkMode = v),
              accent: accent,
            ),
            const SizedBox(height: 16),
            _toggleRow(
              label: _sound ? 'Sound: On' : 'Sound: Muted',
              value: _sound,
              onChanged: (v) => setState(() => _sound = v),
              accent: accent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color accent,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 84, 117, 122),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: accent,
        ),
      ],
    );
  }
}