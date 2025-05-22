import 'package:flutter/material.dart';
import 'package:video/videoplayerwidget.dart';
import 'package:video/fitness_timer_page_1.dart';
import 'screens/home_page.dart';
import 'package:get_storage/get_storage.dart';
//这是一个test

class ExerciseVideo extends StatefulWidget {
  //final String workoutId;
  const ExerciseVideo({super.key});
  @override
  ExerciseVideoState createState() => ExerciseVideoState();
}

class ExerciseVideoState extends State<ExerciseVideo> {
  @override
  final box = GetStorage();
  bool isLiked = false;
  bool isGo = true;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    isGo = box.read('isGo') ?? false;
    isDone = box.read('isDone') ?? false;
  }

  void _onGoPressed() {
    if (!isGo) {
      setState(() {
        isGo = true;
        box.write('isGo', true); // 保存状态
      });
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FitnessTimerPage1()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //页面主体部分
            children: [
              Expanded(
                child: Container(
                  color: Color(0xFFFFFFFF),
                  width: double.infinity,
                  height: double.infinity,
                  //可滚动视图
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //返回按钮
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FitnessHomePage(),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 17,
                              bottom: 13,
                              left: 13,
                            ),
                            width: 22,
                            height: 22,
                            child: Image.asset(
                              'assets/images/back.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        //视频封面（可点击）
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const VideoPlayerPage(
                                      videoUrl: 'assets/videos/intro.mp4',
                                    ),
                              ),
                            );
                          },
                          //橘黄色卡片区
                          child: IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10), //圆角
                                color: Color(0xFFFFBA39),
                              ),
                              //上下内边距
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              margin: const EdgeInsets.only(
                                bottom: 16,
                                left: 24,
                                right: 24,
                              ),
                              width: double.infinity,
                              //视频中间小人（视频预览图）
                              child: Column(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 190,
                                    child: Image.asset(
                                      'assets/images/cover.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        IntrinsicWidth(
                          child: IntrinsicHeight(
                            //评分与标题
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 17,
                                left: 24,
                              ),
                              child: Row(
                                children: [
                                  IntrinsicWidth(
                                    child: IntrinsicHeight(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          color: Color(0xFFD8E3FF),
                                        ),
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          bottom: 4,
                                          left: 8,
                                          right: 10,
                                        ),
                                        margin: const EdgeInsets.only(
                                          right: 11,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                right: 5,
                                              ),
                                              width: 14,
                                              height: 14,
                                              child: Image.asset(
                                                'assets/images/star.png',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Text(
                                              "8.6",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  //标题
                                  Text(
                                    "Sour and Refreshing Slim Belly",
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        IntrinsicWidth(
                          child: IntrinsicHeight(
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 2,
                                left: 32,
                              ),
                              //时间和卡路里
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 31),
                                    child: Text(
                                      "12",
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "76-114",
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        IntrinsicWidth(
                          child: IntrinsicHeight(
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 15,
                                left: 33,
                              ),
                              //底下小字
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 45),
                                    child: Text(
                                      "min",
                                      style: TextStyle(
                                        color: Color(0xFF979797),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "kcal",
                                    style: TextStyle(
                                      color: Color(0xFF979797),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //介绍
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 20,
                            left: 24,
                            right: 24,
                          ),
                          width: double.infinity,
                          child: ExpandableText(
                            text:
                                "Series Update! In this class, on the basis of abdominal shaping, cardiopulmonary exercises are added to increase calorie consumption, so that the vest line can be effective faster~"
                                "\n\nThis series is specially developed for quickly training vest lines. The course adds segmented crunches, and the abdominal cross twists are interspersed in the class to recruit abdominal muscles to the maximum extent and train vest lines efficiently."
                                "\n\n✰ Suitable people"
                                "\n • People who want to quickly train vest lines"
                                "\n • People who find it easy to train vest lines, but find it\n   too difficult to train sister Pa"
                                "\n • People who like the sour feeling of the abdomen"
                                "\n\n✰ Course recommendations"
                                "\n • This course is K2 difficulty, and it is recommended to\n    practice 2-3 times a week"
                                "\n • Three points of training, seven points of eating, pay\n   attention to controlling your diet while training, and\n   control it to 1300-1500 kca per day"
                                "\n\n✰ Contraindications"
                                "\n • Elderly people (over 65 years old), pregnant women, \n   and disabled people"
                                "\n • People with diabetes, cardiovascular and \n   cerebrovascular diseases, lung diseases and other\n   metabolic diseases"
                                "\n • People who have orthopedic injuries and have not yet\n   recovered"
                                "\n • And other people who are advised by doctors not to\n   exercise",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        //What you will do部分
                        Container(
                          margin: const EdgeInsets.only(bottom: 22, left: 24),
                          child: Text(
                            "What you’ll do",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        //Exercise 1
                        ExercisePartCard(
                          imageUrl: "assets/images/exercise1.png",
                          title: "Breathing Vitality Inner Core",
                          time: "00 : 31",
                          stepText: "Step 1",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const VideoPlayerPage(
                                      videoUrl: 'assets/videos/ex1.mp4',
                                    ),
                              ),
                            );
                          },
                        ),
                        //Exercise 2
                        ExercisePartCard(
                          imageUrl: "assets/images/exercise2.png",
                          title: "Alternate Thigh Extension",
                          time: "02 : 44",
                          stepText: "Step 2",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const VideoPlayerPage(
                                      videoUrl: 'assets/videos/ex2.mp4',
                                    ),
                              ),
                            );
                          },
                        ),
                        //Exercise 3
                        ExercisePartCard(
                          imageUrl: "assets/images/exercise3.png",
                          title: "Alternate Thighs",
                          time: "05 : 08",
                          stepText: "Step 3",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const VideoPlayerPage(
                                      videoUrl: 'assets/videos/ex3.mp4',
                                    ),
                              ),
                            );
                          },
                        ),
                        //Exercise 4
                        ExercisePartCard(
                          imageUrl: "assets/images/exercise4.png",
                          title: "Static Crunch Activation",
                          time: "06 : 53",
                          stepText: "Step 4",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const VideoPlayerPage(
                                      videoUrl: 'assets/videos/ex4.mp4',
                                    ),
                              ),
                            );
                          },
                        ),
                        //Exercise 5
                        ExercisePartCard(
                          imageUrl: "assets/images/exercise5.png",
                          title: "Thigh Drop",
                          time: "08 : 41",
                          stepText: "Step 5",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const VideoPlayerPage(
                                      videoUrl: 'assets/videos/ex5.mp4',
                                    ),
                              ),
                            );
                          },
                        ),
                        //Exercise 6
                        ExercisePartCard(
                          imageUrl: "assets/images/exercise6.png",
                          title: "Stretch and Relax",
                          time: "11 : 14",
                          stepText: "Step 6",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const VideoPlayerPage(
                                      videoUrl: 'assets/videos/ex6.mp4',
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //底部
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: Offset(0, -2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:
                                  isLiked
                                      ? Color(0xFFF299A5)
                                      : Color.fromARGB(255, 184, 184, 184),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/like.png',
                                  width: 22,
                                  height: 22,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Like",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: InkWell(
                          onTap: _onGoPressed,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFCE313),
                            ),
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  "GO",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 15,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/Go.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 显示状态
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:
                                  isDone
                                      ? const Color.fromARGB(
                                        255,
                                        102,
                                        212,
                                        106,
                                      ) // ✅ 如果完成，显示绿色
                                      : isGo
                                      ? Color.fromARGB(
                                        255,
                                        255,
                                        218,
                                        118,
                                      ) // 进行中，黄色
                                      : Color(0xFFEFEFEF), // 未进行，灰色
                            ),
                            child: Center(
                              child: Text(
                                isDone
                                    ? "Done" // ✅ 优先显示 Done
                                    : isGo
                                    ? "Ongoing"
                                    : "Undone",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style; // 新增 style 参数

  const ExpandableText({
    Key? key,
    required this.text,
    this.style, // 可选参数
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          textAlign: TextAlign.justify,
          style: widget.style ?? const TextStyle(fontSize: 14), // 使用传入的 style
          maxLines: _isExpanded ? null : 2,
          overflow: TextOverflow.fade,
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            _isExpanded ? "Show Less" : "View More",
            style: const TextStyle(color: Colors.blue, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class ExercisePartCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String time;
  final String stepText;
  final VoidCallback? onTap;

  const ExercisePartCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.time,
    required this.stepText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
        width: double.infinity,
        child: Row(
          children: [
            // 图片
            Container(
              margin: const EdgeInsets.only(right: 15),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xFFD7E3FE), // 背景颜色，可根据需要调整
                borderRadius: BorderRadius.circular(5), // 加圆角
              ),
              child: Image.asset(imageUrl, fit: BoxFit.contain),
            ),
            // 文本部分
            Expanded(
              child: IntrinsicHeight(
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Color(0xFF797979),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 按钮
            InkWell(
              onTap: onTap,
              child: IntrinsicWidth(
                child: IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFEC7401),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          stepText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Image.asset(
                          'assets/images/play-button.png',
                          width: 12,
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
