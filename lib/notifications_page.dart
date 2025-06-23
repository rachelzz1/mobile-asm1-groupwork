// notifications_page.dart
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _soundEnabled = true; // Default state for Sound notification switch
  bool _emailEnabled = false; // Default state for Email notification switch

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
          'Notifications', // Title for the Notifications page
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
              // Sound Notification Switch
              _buildNotificationToggle(
                title: 'Sound',
                value: _soundEnabled,
                onChanged: (bool newValue) {
                  setState(() {
                    _soundEnabled =
                        newValue; // Update the state when switch changes
                  });
                  print('Sound Notifications: $newValue'); // For debugging
                },
              ),
              const SizedBox(height: 16.0), // Spacing between toggles
              // Email Notification Switch
              _buildNotificationToggle(
                title: 'Email',
                value: _emailEnabled,
                onChanged: (bool newValue) {
                  setState(() {
                    _emailEnabled =
                        newValue; // Update the state when switch changes
                  });
                  print('Email Notifications: $newValue'); // For debugging
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build a single notification toggle item
  Widget _buildNotificationToggle({
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
