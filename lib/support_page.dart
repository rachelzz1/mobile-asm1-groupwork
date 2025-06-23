// support_page.dart
import 'package:flutter/material.dart';
import 'answer_page.dart'; // Ensure this import is present
import 'contact.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Support', style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0x52E9D2A6), // The yellow background color
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Hi, Kris',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'How can I help you',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search For Questions',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      ),
                      onSubmitted: (value) {
                        print('Search submitted: $value');
                      },
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Most Frequently Asked Questions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMFQCard(
                          numberImagePath: 'assets/images/number1.png', //
                          title:
                              '[Function] How can I invite friends to participate in the PK function?',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const AnswerPage(
                                      questionTitle:
                                          '[Function] How can I invite friends to participate in the PK function?',
                                      answerContent:
                                          'To invite friends, navigate to the "Friends" section in the app, select the "Invite" option, and choose your preferred method (e.g., share link, social media). Your friends can then use this invitation to join the PK function. Ensure they have the latest version of the app for full compatibility.',
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: _buildMFQCard(
                          numberImagePath: 'assets/images/2.png',
                          title:
                              '[Account] What can I do to avoid problems if I forget my passport?',
                          onTap: () {
                            // NEW NAVIGATION FOR MFQ ITEM 2
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const AnswerPage(
                                      questionTitle:
                                          '[Account] What can I do to avoid problems if I forget my passport?',
                                      answerContent:
                                          'If you forget your password, please go to the login screen and click on "Forgot Password". Follow the instructions to reset your password using your registered email or phone number. If you encounter any issues, please contact our support team.',
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24.0),
                  _buildSupportButton(
                    iconImagePath: 'assets/images/guidance.png',
                    title: 'User guidance',
                    backgroundColor: const Color(0xFFFFFCF6),
                    onTap: () {
                      print('Tapped User guidance');
                      // TODO: Implement navigation for User guidance
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _buildSupportButton(
                    iconImagePath: 'assets/images/chat.png',
                    title: 'Contact with us',
                    backgroundColor: const Color(0xFFFFFCF6),
                    onTap: () {
                      print('Tapped Contact with us');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Contact(),
                        ), // <--- NEW NAVIGATION TO SupportPage
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMFQCard({
    required String numberImagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white, // MFQ卡片本身的背景是白色
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(numberImagePath, width: 40, height: 40),
            const SizedBox(height: 8.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFB8D00),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportButton({
    required String iconImagePath,
    required String title,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(iconImagePath, width: 28, height: 28),
            const SizedBox(width: 16.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
