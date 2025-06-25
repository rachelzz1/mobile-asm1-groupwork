// lib/user_details_screen.dart

import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 添加一个返回按钮的 AppBar
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // 让返回箭头和标题是黑色
        elevation: 0, // 去掉阴影
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        // 使用 ListView 防止内容超出一屏时无法滚动
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

  // 一个辅助 Widget，用于创建统一风格的列表项，使代码更整洁
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
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