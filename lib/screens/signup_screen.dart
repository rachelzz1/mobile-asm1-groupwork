// lib/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_page.dart';
import 'login_screen.dart';
import 'welcome_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final titleSpacing = screenHeight * 0.018;
    final inputSpacing = screenHeight * 0.015;
    final buttonHeight = screenHeight * 0.07;
    final socialButtonSpacing = screenHeight * 0.01;
    final bottomSpacing = screenHeight * 0.02;

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
                'Sign Up',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: darkTextColor,
                ),
              ),
              SizedBox(height: titleSpacing),
              Text(
                'Create your account, it takes less than a minute. Enter your email and password.',
                style: TextStyle(fontSize: subtitleFontSize, color: lightTextColor),
              ),
              SizedBox(height: titleSpacing * 1.5),

              _buildTextField(
                controller: _emailController,
                hint: 'Email',
              ),
              SizedBox(height: inputSpacing),

              _buildTextField(
                controller: _passwordController,
                hint: 'Password',
                isPassword: true,
              ),
              SizedBox(height: titleSpacing * 1.5),

              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled ? yellowColor : const Color.fromARGB(255, 132, 132, 132),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  // 2. 修改这里的跳转逻辑
                  onPressed: _isButtonEnabled
                      ? () {
                          // 跳转到主页并清除导航堆栈
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const FitnessHomePage()),
                            (route) => false, // 清除所有旧路由
                          );
                        }
                      : null,
                  child: Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: titleSpacing),

              _buildDivider(),
              SizedBox(height: socialButtonSpacing),

              _buildSocialButton(
                icon: FontAwesomeIcons.google,
                text: 'Continue with Google',
                color: brownColor,
                buttonHeight: buttonHeight,
              ),
              SizedBox(height: socialButtonSpacing),
              _buildSocialButton(
                icon: FontAwesomeIcons.facebook,
                text: 'Continue with Facebook',
                color: brownColor,
                buttonHeight: buttonHeight,
              ),
              SizedBox(height: socialButtonSpacing),
              _buildSocialButton(
                icon: FontAwesomeIcons.apple,
                text: 'Continue with Apple',
                color: brownColor,
                buttonHeight: buttonHeight,
              ),
              SizedBox(height: bottomSpacing),
              _buildLoginLink(context),
            ],
          ),
        ),
      ),
    );
  }

  // ... 以下的辅助方法保持不变 ...
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
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

  Widget _buildSocialButton({
    required IconData icon,
    required String text,
    required Color color,
    required double buttonHeight,
  }) {
    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton.icon(
        icon: FaIcon(
          icon,
          color: Colors.white,
          size: buttonHeight * 0.4,
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: buttonHeight * 0.3,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.0),
          ),
        ),
        onPressed: () {
          print('$text button pressed');
        },
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Already have an account? ", style: TextStyle(color: Colors.grey[600])),
        GestureDetector(
          onTap: () {
            print('Log in link tapped');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()), 
            );
          },
          child: const Text(
            'Log in',
            style: TextStyle(
              color: Color(0xFFF57C00),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}