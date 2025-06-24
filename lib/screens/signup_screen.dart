// lib/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// 1. 导入 Firestore 包
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'login_screen.dart';
import 'welcome_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // 2. 为 Username 添加新的控制器
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // 3. 监听所有控制器的变化
    _usernameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    // 4. 更新按钮状态逻辑，确保所有字段都已填写
    setState(() {
      _isButtonEnabled = _usernameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }
  
  // 5. 创建核心的注册函数
  Future<void> _signUp() async {
    // 显示加载动画
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 检查邮箱是否已存在
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailController.text.trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Navigator.pop(context); // 关闭加载动画
        // 邮箱已存在，显示错误提示
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This email is already in use.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return; // 提前退出函数
      }

      // 邮箱不存在，创建新用户
      await FirebaseFirestore.instance.collection('users').add({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'createdAt': Timestamp.now(),
      });
      
      Navigator.pop(context); // 关闭加载动画

      // 注册成功，跳转到主页
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const FitnessHomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      Navigator.pop(context); // 关闭加载动画
      // 处理其他可能的 Firestore 错误
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
                'Create your account, it takes less than a minute. Enter your username, email and password.',
                style: TextStyle(fontSize: subtitleFontSize, color: lightTextColor),
              ),
              SizedBox(height: titleSpacing * 1.5),
              
              // 6. 添加 Username 输入框
              _buildTextField(
                controller: _usernameController,
                hint: 'Username',
              ),
              SizedBox(height: inputSpacing),

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
                    backgroundColor: _isButtonEnabled ? yellowColor : Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  // 7. 将按钮的 onPressed 事件连接到我们的注册函数
                  onPressed: _isButtonEnabled ? _signUp : null,
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