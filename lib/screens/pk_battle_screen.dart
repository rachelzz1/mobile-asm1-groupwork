// lib/pk_battle_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 顶部引入

import '../widgets/pk_progress_bar.dart';
import '../widgets/pk_attribute_comparison.dart';
import '../widgets/pk_result_panel.dart';
import 'home_page.dart';
import '../screens/calendar.dart';
import 'profile.dart';

class PKBattleScreen extends StatefulWidget {
  final String userId;
  final String username;
  //接收ID和用户名
  const PKBattleScreen({Key? key, required this.userId, required this.username}) : super(key: key);

  @override
  State<PKBattleScreen> createState() => _PKBattleScreenState();
}

class _PKBattleScreenState extends State<PKBattleScreen>
    with TickerProviderStateMixin {
  static const Color themeOrange = Color(0xFFFFBA3A);

  int _currentIndex = 2;
  late AnimationController _panelAnimationController;
  final ValueNotifier<bool> _allAttributeAnimationsDoneNotifier = ValueNotifier(
    false,
  );
  final ValueNotifier<double> _progressBarWidthFactor = ValueNotifier<double>(
    0.0,
  );
  bool _showResultPanel = false;
  String _winnerText = "";
  String _winnerAvatarPath = "";

  Map<String, int> _pkAttributes = {
    "endurance": 0,
    "burst": 0,
    "strength": 0,
    "flexibility": 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchPkAttributes(); // 新增
    _progressBarWidthFactor.value = 0.0;
    _panelAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _allAttributeAnimationsDoneNotifier.addListener(_handleAllAnimationsDone);
    _showResultPanel = false;
    _winnerText = "";
    _winnerAvatarPath = "";
  }
// 从 Firestore 获取 PK 属性
  Future<Map<String, int>> _fetchPkAttributes() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    if (doc.exists && doc.data()?['pkAttributes'] != null) {
      return Map<String, int>.from(doc.data()!['pkAttributes']);
    }
    // 返回默认值
    return {
      "endurance": 0,
      "burst": 0,
      "strength": 0,
      "flexibility": 0,
    };
  }

  void _handleAllAnimationsDone() {
    if (_allAttributeAnimationsDoneNotifier.value) {
      final double progress = _progressBarWidthFactor.value;
      if (progress > 0.5001) {
        _winnerText = "You Win!";
        _winnerAvatarPath = 'assets/images/girl.png';
      } else if (progress < 0.4999) {
        _winnerText = "Kris Wins!";
        _winnerAvatarPath = 'assets/images/boy.png';
      } else {
        _winnerText = "It's a Tie!";
        _winnerAvatarPath = '';
      }


      Future.delayed(const Duration(seconds: 1), () { 

        if (mounted) {
          setState(() {
            _showResultPanel = true;
          });
          _panelAnimationController.forward();
        }
      });
    }
  }

  void _closeResultPanel() {
    if (mounted) {
      _panelAnimationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showResultPanel = false;
          });
        }
      });
    }
  }

  void _onRematch() {
    _closeResultPanel();
    Future.delayed(
      Duration(
        milliseconds: _panelAnimationController.duration?.inMilliseconds ?? 200,
      ),
      () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PKBattleScreen(
                userId: widget.userId,
                username: widget.username,
              ),
            ),
          );
        }
      },
    );
  }

  void _onViewStats() {
    _closeResultPanel();
    print("View Stats Tapped");
  }

  @override
  void dispose() {
    _allAttributeAnimationsDoneNotifier.removeListener(
      _handleAllAnimationsDone,
    );
    _allAttributeAnimationsDoneNotifier.dispose();
    _panelAnimationController.dispose();
    _progressBarWidthFactor.dispose();
    super.dispose();
  }

  Widget _buildNavItem(
    BuildContext context,
    String iconPath,
    String label,
    int index,
    double iconSize,
  ) {
    bool isActive = _currentIndex == index;
    Color color = isActive ? themeOrange : const Color(0xFFBDBDBD);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (mounted) {
            if (_currentIndex == index && index == 2) {
              if (_showResultPanel) {
                _closeResultPanel();
              }
            } else if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => FitnessHomePage(
                    userId: widget.userId,
                    username: widget.username,
                  ),
                ),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarPage(
                    userId: widget.userId,
                    username: widget.username,
                  ),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                  userId: widget.userId,
                  username: widget.username,
                  ),
                ),
              );
              if (index == 2 && _currentIndex != 2) {}
            }
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerColumn(
    BuildContext context,
    String avatarPath,
    String playerName,
    double avatarSize,
    double nameFontSize,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(4, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: CircleAvatar(
              radius: avatarSize / 2,
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(avatarSize * 0.08),
                child: Image.asset(avatarPath, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          playerName,
          style: TextStyle(
            fontSize: nameFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double bottomNavIconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final double maxHeight = constraints.maxHeight;
            final double pageHorizontalPadding = maxWidth * 0.04;
            final double avatarSize = maxWidth * 0.28;
            final double vsFontSize = maxWidth * 0.1;
            final double counterFontSize = maxWidth * 0.09;
            final double attributeContainerMargin = maxHeight * 0.025;

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: pageHorizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: maxHeight * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPlayerColumn(
                              context,
                              'assets/images/girl.png',
                              widget.username, // 用当前登录用户名
                              avatarSize,
                              counterFontSize,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: avatarSize * 0.35),
                              child: Text(
                                'VS',
                                style: TextStyle(
                                  fontSize: vsFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            _buildPlayerColumn(
                              context,
                              'assets/images/boy.png',
                              'Kris',
                              avatarSize,
                              counterFontSize,
                            ),
                          ],
                        ),
                        SizedBox(height: maxHeight * 0.015),
                        PKProgressBar(
                          maxWidth: maxWidth,
                          progressBarWidthFactor: _progressBarWidthFactor,
                        ),
                        SizedBox(height: attributeContainerMargin),
                        FutureBuilder<Map<String, int>>(
                          future: _fetchPkAttributes(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final pkAttributes = snapshot.data!;
                            // 渲染 PKAttributeComparisonContainer
                            return PKAttributeComparisonContainer(
                              parentWidth: maxWidth,
                              onAllAnimationsComplete:
                                  _allAttributeAnimationsDoneNotifier,
                              progressBarWidthFactor: _progressBarWidthFactor,
                              leftAttributes: pkAttributes,
                            );
                          },
                        ),
                        SizedBox(height: maxHeight * 0.12),
                      ],
                    ),
                  ),
                ),
                if (_showResultPanel)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                      child: PKResultPanel(
                        winnerText: _winnerText,
                        winnerAvatarPath: _winnerAvatarPath,
                        maxWidth: maxWidth,
                        onClose: _closeResultPanel,
                        onRematch: _onRematch,
                        onViewStats: _onViewStats,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(
              context,
              'assets/icons/home.svg',
              'Home',
              0,
              bottomNavIconSize,
            ),
            _buildNavItem(
              context,
              'assets/icons/calendar.svg',
              'Calendar',
              1,
              bottomNavIconSize,
            ),
            _buildNavItem(
              context,
              'assets/icons/PK.svg',
              'PK',
              2,
              bottomNavIconSize,
            ),
            _buildNavItem(
              context,
              'assets/icons/profile.svg',
              'Profile',
              3,
              bottomNavIconSize,
            ),
          ],
        ),
      ),
    );
  }
}
