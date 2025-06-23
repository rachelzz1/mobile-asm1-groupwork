// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
// 1. 新增导入，让文件认识 FitnessHomePage
import 'home_page.dart'; 
import 'signup_screen.dart'; 
import 'welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _userController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _userController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final titleSpacing = screenHeight * 0.018;
    final inputSpacing = screenHeight * 0.02;
    final buttonHeight = screenHeight * 0.07;
    final titleFontSize = screenHeight * 0.045;
    final subtitleFontSize = screenHeight * 0.018;
    final buttonFontSize = buttonHeight * 0.36;

    const yellowColor = Color(0xFFFFC107);
    const brownColor = Color(0xFF6D4C41);
    const darkTextColor = Color(0xFF333333);
    final lightTextColor = Colors.grey[600];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: titleSpacing),
              Text(
                'Welcome back,',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: darkTextColor,
                ),
              ),
              SizedBox(height: titleSpacing),
              Text(
                'We happy to see you here again. Enter your email address or user id and password.',
                style: TextStyle(fontSize: subtitleFontSize, color: lightTextColor),
              ),
              SizedBox(height: titleSpacing * 2.5),
              _buildTextField(
                controller: _userController,
                hint: 'Email/User ID',
              ),
              SizedBox(height: inputSpacing),
              _buildTextField(
                controller: _passwordController,
                hint: 'Password',
                isPassword: true,
              ),
              SizedBox(height: titleSpacing * 2.5),
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled ? yellowColor : Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  // 2. 修改这里的跳转逻辑
                  onPressed: _isButtonEnabled
                      ? () {
                          // 使用 pushAndRemoveUntil 跳转到主页，并清空之前的页面
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const FitnessHomePage()),
                            (route) => false, // 清除所有旧路由
                          );
                        }
                      : null,
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: titleSpacing * 1.5),
              _buildDivider(),
              SizedBox(height: titleSpacing * 1.5),
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brownColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    // ... (这个辅助方法没有变化)
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Color(0xFFFFC107), width: 2.0),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    // ... (这个辅助方法没有变化)
    return Row(
      children: <Widget>[
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('or', style: TextStyle(color: Colors.grey[500])),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }
}