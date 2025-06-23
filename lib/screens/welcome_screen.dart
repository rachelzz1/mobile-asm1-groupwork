import 'package:flutter/material.dart';
// 确保 login_screen.dart 和 signup_screen.dart 在 lib 文件夹下
import 'login_screen.dart'; 
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // 跳转到注册页
  void _navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()), // 跳转到注册页
    );
  }

  // 跳转到登录页
  void _navigateToLogIn(BuildContext context) {
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    final guyLogoHeight = screenHeight * 0.39;
    final fontLogoHeight = screenHeight * 0.12;
    final buttonWidth = screenWidth * 0.8;
    final buttonHeight = screenHeight * 0.065;
    final logoSpacing = screenHeight * 0.015;
    final mainSpacing = screenHeight * 0.08;
    final buttonSpacing = screenHeight * 0.025;

    final brownColor = Colors.brown[700];
    const yellowColor = Color(0xFFFFD100);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 3),
              Image.asset('assets/images/logo-guy.png', height: guyLogoHeight),
              SizedBox(height: logoSpacing),
              Image.asset('assets/images/logo-font.png', height: fontLogoHeight),
              SizedBox(height: mainSpacing),
              SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    elevation: 0,
                  ),
                  onPressed: () => _navigateToLogIn(context), // Log In 按钮事件
                  child: Text('Log In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: brownColor)),
                ),
              ),
              SizedBox(height: buttonSpacing),
              SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: brownColor,
                    side: const BorderSide(color: yellowColor, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  ),
                  onPressed: () => _navigateToSignUp(context), // Sign Up按钮事件
                  child: const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}