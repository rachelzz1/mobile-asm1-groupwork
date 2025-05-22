// reward_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'exercise_video.dart';

class RewardScreen extends StatefulWidget {
  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  bool isStarVisible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startStarAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startStarAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        isStarVisible = !isStarVisible;
      });
    });
  }

  // 自适应构建星星位置和大小
  List<Widget> buildStars(double width, double height, double starSize) {
    return [
      Positioned(
        top: height * 0.05,
        left: width * 0.3,
        child: buildStar(starSize),
      ),
      Positioned(
        top: height * 0.05,
        right: width * 0.3,
        child: buildStar(starSize),
      ),
      Positioned(
        top: height * 0.15,
        left: width * 0.1,
        child: buildStar(starSize),
      ),
      Positioned(
        top: height * 0.15,
        right: width * 0.1,
        child: buildStar(starSize),
      ),
      Positioned(
        top: height * 0.3,
        left: width * 0.07,
        child: buildStar(starSize),
      ),
      Positioned(
        top: height * 0.3,
        right: width * 0.07,
        child: buildStar(starSize),
      ),
      Positioned(
        top: height * 0.4,
        right: width * 0.25,
        child: buildStar(starSize),
      ),
      Positioned(
        top: height * 0.4,
        left: width * 0.25,
        child: buildStar(starSize),
      ),
    ];
  }

  Widget buildStar(double size) {
    return isStarVisible
        ? Image.asset(
          'assets/images/stars.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        )
        : SizedBox(width: size, height: size);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    // 根据屏幕宽度设定星星大小（大约屏幕宽度的8%）
    final starSize = screenWidth * 0.08;

    return Scaffold(
      appBar: AppBar(
        title: Text("Reward", style: TextStyle(fontSize: screenWidth * 0.05)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: screenWidth * 0.07),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExerciseVideo()),
            );
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 背景图片 自适应大小和位置
          Positioned(
            top: screenHeight * 0.15,
            child: Image.asset(
              'assets/images/good.png',
              width: screenWidth * 0.4,
              height: screenWidth * 0.4,
              fit: BoxFit.contain,
            ),
          ),

          // 环绕星星
          ...buildStars(screenWidth, screenHeight, starSize),

          // 任务信息框
          Positioned(
            bottom: screenHeight * 0.15,
            child: Column(
              children: [
                Text(
                  "Complete the task 1 !",
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // 第一个任务框
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.002),
                      child: Image.asset(
                        'assets/images/yellowicon.png',
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Container(
                      width: screenWidth * 0.55,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.007,
                        horizontal: screenWidth * 0.07,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF8DFB0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Today task: ',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: '1/4',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.012),

                // 第二个任务框
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.002),
                      child: Image.asset(
                        'assets/images/blueicon.png',
                        width: screenWidth * 0.12,
                        height: screenWidth * 0.12,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Container(
                      width: screenWidth * 0.55,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.007,
                        horizontal: screenWidth * 0.07,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFAFEAE9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Game Points ',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: '+10',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Next Task 按钮
          Positioned(
            bottom: screenHeight * 0.05,
            right: screenWidth * 0.05,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.015,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Next Task",
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
