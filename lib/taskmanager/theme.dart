import 'package:flutter/material.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  bool _isDarkModeEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme'),
        automaticallyImplyLeading: false,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Dark Mode',
            style: TextStyle(fontSize: 16),
          ),
          Switch(
            value: _isDarkModeEnabled,
            onChanged: (value) {
              setState(() {
                _isDarkModeEnabled = value;
                // Add logic to change theme mode here
              });
              print(_isDarkModeEnabled);
            },
          ),
          Icon(_isDarkModeEnabled ? Icons.dark_mode : Icons.light_mode),
        ],
      ),
    );
  }
}
