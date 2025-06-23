// language_page.dart
import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  // We'll manage these as mutually exclusive, so only one can be true at a time.
  bool _englishEnabled = true;
  bool _chineseEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous page
          },
        ),
        title: const Text(
          'Language', // Title for the Language page
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the content
          child: Column(
            children: [
              // English Language Toggle
              _buildLanguageToggle(
                title: 'English',
                value: _englishEnabled,
                onChanged: (bool newValue) {
                  setState(() {
                    if (newValue) {
                      // If English is turned ON
                      _englishEnabled = true;
                      _chineseEnabled = false; // Turn off Chinese
                    } else {
                      // If English is turned OFF
                      // If both are off, default to English, or handle appropriately
                      _englishEnabled = false;
                      if (!_chineseEnabled) {
                        // If Chinese is also off, turn English back on (or set a default)
                        _englishEnabled = true; // Prevents both being off
                      }
                    }
                  });
                  print('English: $newValue'); // For debugging
                },
              ),
              const SizedBox(height: 16.0), // Spacing between toggles
              // Chinese Language Toggle
              _buildLanguageToggle(
                title: 'Chinese',
                value: _chineseEnabled,
                onChanged: (bool newValue) {
                  setState(() {
                    if (newValue) {
                      // If Chinese is turned ON
                      _chineseEnabled = true;
                      _englishEnabled = false; // Turn off English
                    } else {
                      // If Chinese is turned OFF
                      _chineseEnabled = false;
                      if (!_englishEnabled) {
                        // If English is also off, turn Chinese back on (or set a default)
                        _chineseEnabled = true; // Prevents both being off
                      }
                    }
                  });
                  print('Chinese: $newValue'); // For debugging
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build a single language toggle item
  Widget _buildLanguageToggle({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100], // Background color for the toggle container
        borderRadius: BorderRadius.circular(
          10.0,
        ), // Rounded corners for the container
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        value: value, // Current state of the switch
        onChanged: onChanged, // Callback when the switch is toggled
        activeColor: Colors.blue, // Color when the switch is ON
        inactiveTrackColor:
            Colors.grey[300], // Track color when the switch is OFF
      ),
    );
  }
}
