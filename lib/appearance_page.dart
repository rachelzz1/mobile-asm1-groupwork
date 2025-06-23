// appearance_page.dart
import 'package:flutter/material.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({Key? key}) : super(key: key);

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  // We'll manage these as mutually exclusive, representing Light/Night mode.
  bool _lightModeEnabled = true; // Default to Light mode
  bool _nightModeEnabled = false; // Default to Night mode off

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
          'Appearance', // Title for the Appearance page
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
              // Light Mode Toggle
              _buildAppearanceToggle(
                title: 'Light',
                value: _lightModeEnabled,
                onChanged: (bool newValue) {
                  setState(() {
                    if (newValue) {
                      // If Light mode is turned ON
                      _lightModeEnabled = true;
                      _nightModeEnabled = false; // Turn off Night mode
                    } else {
                      // If Light mode is turned OFF
                      // If both are off, default to Light, or handle appropriately
                      _lightModeEnabled = false;
                      if (!_nightModeEnabled) {
                        // If Night mode is also off, turn Light mode back on (or set a default)
                        _lightModeEnabled = true; // Prevents both being off
                      }
                    }
                  });
                  print('Light Mode: $newValue'); // For debugging
                },
              ),
              const SizedBox(height: 16.0), // Spacing between toggles
              // Night Mode Toggle
              _buildAppearanceToggle(
                title: 'Night',
                value: _nightModeEnabled,
                onChanged: (bool newValue) {
                  setState(() {
                    if (newValue) {
                      // If Night mode is turned ON
                      _nightModeEnabled = true;
                      _lightModeEnabled = false; // Turn off Light mode
                    } else {
                      // If Night mode is turned OFF
                      _nightModeEnabled = false;
                      if (!_lightModeEnabled) {
                        // If Light mode is also off, turn Night mode back on (or set a default)
                        _nightModeEnabled = true; // Prevents both being off
                      }
                    }
                  });
                  print('Night Mode: $newValue'); // For debugging
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build a single appearance toggle item
  Widget _buildAppearanceToggle({
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
