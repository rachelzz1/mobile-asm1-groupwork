// account_security_page.dart
import 'package:flutter/material.dart';

class AccountSecurityPage extends StatefulWidget {
  const AccountSecurityPage({Key? key}) : super(key: key);

  @override
  State<AccountSecurityPage> createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {
  bool _facialRecognitionEnabled =
      true; // Default state for Facial Recognition switch
  bool _dataBackupEnabled = false; // Default state for Data Backup switch
  bool _accountVerificationEnabled =
      true; // Default state for Account Verification switch

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
          'Accounting Security', // Title for the Account Security page
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
              // Facial Recognition Switch
              _buildSecurityToggle(
                title: 'Facial Recognition',
                value: _facialRecognitionEnabled,
                onChanged: (bool newValue) {
                  setState(() {
                    _facialRecognitionEnabled =
                        newValue; // Update the state when switch changes
                  });
                  print('Facial Recognition: $newValue'); // For debugging
                },
              ),
              const SizedBox(height: 16.0), // Spacing between toggles
              // Data Backup Switch
              _buildSecurityToggle(
                title: 'Data Backup',
                value: _dataBackupEnabled,
                onChanged: (bool newValue) {
                  setState(() {
                    _dataBackupEnabled =
                        newValue; // Update the state when switch changes
                  });
                  print('Data Backup: $newValue'); // For debugging
                },
              ),
              const SizedBox(height: 16.0), // Spacing between toggles
              // Account Verification Switch
              _buildSecurityToggle(
                title: 'Account Verification',
                value: _accountVerificationEnabled,
                onChanged: (bool newValue) {
                  setState(() {
                    _accountVerificationEnabled =
                        newValue; // Update the state when switch changes
                  });
                  print('Account Verification: $newValue'); // For debugging
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build a single security toggle item
  Widget _buildSecurityToggle({
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
