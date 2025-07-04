// lib/user_details_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId; // 需要传入userId

  const UserDetailsScreen({super.key, required this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController genderController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController bustController;
  late TextEditingController waistController;
  late TextEditingController hipsController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    genderController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    bustController = TextEditingController();
    waistController = TextEditingController();
    hipsController = TextEditingController();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
    final data = doc.data() ?? {};
    setState(() {
      nameController.text = data['username'] ?? ''; 
      genderController.text = data['gender'] ?? '';
      heightController.text = data['height']?.toString() ?? '';
      weightController.text = data['weight']?.toString() ?? '';
      bustController.text = data['bust']?.toString() ?? '';
      waistController.text = data['waist']?.toString() ?? '';
      hipsController.text = data['hips']?.toString() ?? '';
      isLoading = false;
    });
  }

  Future<void> _saveUserData() async {
    await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
      'username': nameController.text, 
      'gender': genderController.text,
      'height': heightController.text,
      'weight': weightController.text,
      'bust': bustController.text,
      'waist': waistController.text,
      'hips': hipsController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved!')));
  }

  @override
  void dispose() {
    nameController.dispose();
    genderController.dispose();
    heightController.dispose();
    weightController.dispose();
    bustController.dispose();
    waistController.dispose();
    hipsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveUserData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            _buildEditableItem('Name', nameController),
            _buildEditableDropdown('Gender', genderController, ['female', 'male']),
            _buildEditableItem('Height (cm)', heightController),
            _buildEditableItem('Weight (kg)', weightController),
            Row(
              children: [
                Expanded(child: _buildEditableItem('Bust', bustController)),
                const SizedBox(width: 8),
                Expanded(child: _buildEditableItem('Waist', waistController)),
                const SizedBox(width: 8),
                Expanded(child: _buildEditableItem('Hips', hipsController)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableItem(String label, TextEditingController controller) {
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
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade700,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableDropdown(String label, TextEditingController controller, List<String> options) {
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
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade700,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: DropdownButton<String>(
            value: controller.text.isEmpty ? null : controller.text,
            hint: const Text('Select'),
            isExpanded: true,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                controller.text = newValue ?? '';
              });
            },
          ),
        ),
      ),
    );
  }
}