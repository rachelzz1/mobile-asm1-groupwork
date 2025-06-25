// lib/user_details_screen.dart

import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            _buildDetailItem('Name', 'Kris'),
            _buildDetailItem('Gender', 'Female'),
            _buildDetailItem('Height', '165 cm'),
            _buildDetailItem('Weight', '55.5 kg'),
            _buildDetailItem('Measurements', 'Bust: 90 / Waist: 60 / Hips: 90'),
          ],
        ),
      ),
    );
  }

  // 👇👇👇 修改发生在这里 👇👇👇
  Widget _buildDetailItem(String label, String value) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(
          label,
          // ✅ 这是我们修改后的样式
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade700, // 使用主题蓝色
            fontSize: 15,                 // 增大了字号
            letterSpacing: 0.5,           // 增加了字母间距
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}