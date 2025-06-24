import 'package:flutter/material.dart';
import 'support_page.dart';

class GuidanceScreen extends StatelessWidget {
  const GuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 定义颜色以便复用
    const Color backgroundColor = Color(0xFFFEFBF3);
    const Color primaryTextColor = Color(0xFF4A4A4A);
    const Color borderColor = Color(0xFF7B4F23);
    const Color stepLabelColor = Color(0xFFFFD140);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 顶部标题栏
                _buildHeader(context),
                const SizedBox(height: 30),
                // 步骤 1
                _buildStepCard(
                  borderColor: borderColor,
                  child: _buildStep1Content(stepLabelColor),
                ),
                const SizedBox(height: 20),
                // 步骤 2
                _buildStepCard(
                  borderColor: borderColor,
                  child: _buildStep2Content(stepLabelColor),
                ),
                const SizedBox(height: 20),
                // 步骤 3
                _buildStepCard(
                  borderColor: borderColor,
                  child: _buildStep3Content(stepLabelColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建顶部标题区域
  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => const SupportPage(),
              ), // <--- NEW NAVIGATION TO SupportPage
            );
          },
        ),
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Guidance',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4A4A4A)),
            ),
            Text(
              'How to Use LazyFit?',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
        const Spacer(),
        Column(
          children: [
            Image.asset('assets/images/entire-logo.png', height: 60),
            const Text(
              'LazyFit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF4A4A4A)),
            )
          ],
        )
      ],
    );
  }

  // 构建步骤卡片的通用容器
  Widget _buildStepCard({required Color borderColor, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }

  // 构建步骤标题的通用方法
  Widget _buildStepHeader(int step, String title, Color stepLabelColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: stepLabelColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            'Step $step',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF4A4A4A)),
        ),
      ],
    );
  }

  // 构建步骤 1 的内容
  Widget _buildStep1Content(Color stepLabelColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(1, 'Choose the program you like', stepLabelColor),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/think.png', height: 80),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.black54),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Yoga', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Burpee', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Dance', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('...', style: TextStyle(fontSize: 16, letterSpacing: 2)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 构建步骤 2 的内容
  Widget _buildStep2Content(Color stepLabelColor) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepHeader(2, 'Following the steps', stepLabelColor),
                const SizedBox(height: 15),
                const Text(
                  'Static Crunch Activation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                const Text('00 : 14', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 15),
              ],
            ),
            Positioned(
              top: 30,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5E3C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Step 1', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/run1.png', height: 70),
            const SizedBox(width: 10),
            Image.asset('assets/images/run2.png', height: 70),
            const SizedBox(width: 10),
            Image.asset('assets/images/run3.png', height: 70),
          ],
        ),
      ],
    );
  }

  // 构建步骤 3 的内容
  Widget _buildStep3Content(Color stepLabelColor) {
    return Column(
      children: [
        _buildStepHeader(3, 'Have exciting PK with others', stepLabelColor),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset('assets/images/num1.png', height: 80),
                const SizedBox(height: 8),
                const Text('Endurance', style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const Text('VS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Column(
              children: [
                Image.asset('assets/images/num2.png', height: 80),
                const SizedBox(height: 8),
                const Text('Strength', style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}