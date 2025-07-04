// PKBattleScreen：PK对战主界面，包含属性对比动画、进度条、结果弹窗和底部导航

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 引入Firestore用于获取用户属性
import 'package:audioplayers/audioplayers.dart';

import '../widgets/pk_progress_bar.dart';           // 进度条组件
import '../widgets/pk_attribute_comparison.dart';   // 属性对比动画组件
import '../widgets/pk_result_panel.dart';           // 结果弹窗组件
import 'home_page.dart';
import '../screens/calendar.dart';
import 'profile.dart';

class PKBattleScreen extends StatefulWidget {
  final String userId;      
  final String username;    
  // 构造函数，接收ID和用户名
  const PKBattleScreen({Key? key, required this.userId, required this.username}) : super(key: key);

  @override
  State<PKBattleScreen> createState() => _PKBattleScreenState();
}

class _PKBattleScreenState extends State<PKBattleScreen>
    with TickerProviderStateMixin {
  static const Color themeOrange = Color(0xFFFFBA3A);

  int _currentIndex = 2; // 当前底部导航索引，2为PK
  late AnimationController _panelAnimationController; // 结果弹窗动画控制器
  final ValueNotifier<bool> _allAttributeAnimationsDoneNotifier = ValueNotifier(
    false,
  ); // 属性动画完成通知
  final ValueNotifier<double> _progressBarWidthFactor = ValueNotifier<double>(
    0.0,
  ); // 进度条宽度（胜率）
  bool _showResultPanel = false; // 是否显示结果弹窗
  String _winnerText = "";       // 胜负文字
  String _winnerAvatarPath = ""; // 胜者头像路径

  final AudioPlayer _resultAudioPlayer = AudioPlayer(); 

  // 当前用户PK属性（默认值）
  Map<String, int> _pkAttributes = {
    "endurance": 0,
    "burst": 0,
    "strength": 0,
    "flexibility": 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchPkAttributes(); // 获取当前用户PK属性
    _progressBarWidthFactor.value = 0.0;
    _panelAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _allAttributeAnimationsDoneNotifier.addListener(_handleAllAnimationsDone); // 监听动画完成
    _showResultPanel = false;
    _winnerText = "";
    _winnerAvatarPath = "";
  }

  // 从 Firestore 获取当前用户的PK属性
  Future<Map<String, int>> _fetchPkAttributes() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    if (doc.exists && doc.data()?['pkAttributes'] != null) {
      return Map<String, int>.from(doc.data()!['pkAttributes']);
    }
    // 若无数据，返回默认值
    return {
      "endurance": 0,
      "burst": 0,
      "strength": 0,
      "flexibility": 0,
    };
  }

  // 属性动画全部完成后，判断胜负并弹窗
  void _handleAllAnimationsDone() async {
    if (_allAttributeAnimationsDoneNotifier.value) {
      final double progress = _progressBarWidthFactor.value;
      if (progress > 0.5001) {
        _winnerText = "You Win!"; 
        _winnerAvatarPath = 'assets/images/girl.png';
        // 播放胜利音效
        await _resultAudioPlayer.play(AssetSource('audios/level-win.mp3'));
      } else if (progress < 0.4999) {
        _winnerText = "Oliver Wins!"; 
        _winnerAvatarPath = 'assets/images/boy.png';
        // 播放失败音效
        await _resultAudioPlayer.play(AssetSource('audios/losing-horn.mp3'));
      } else {
        _winnerText = "It's a Tie!"; 
        _winnerAvatarPath = '';
        // 平局不播放音效
      }

      // 延迟1秒后弹出结果面板
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

  // 关闭结果弹窗
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

  // 再来一局，重置界面
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

  // 查看数据回调（可自定义跳转）
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
    _resultAudioPlayer.dispose(); // 释放音效资源
    super.dispose();
  }

  // 构建底部导航栏的单个按钮
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

  // 构建玩家头像和昵称
  Widget _buildPlayerColumn(
    BuildContext context,
    String avatarPath,
    String playerName,
    double avatarSize,
    double nameFontSize,
  ) {
    return Column(// 使用 Column 来垂直排列头像和昵称
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(// 使用 Container 包裹头像，添加阴影效果
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

            return Stack(// 使用 Stack 来叠加内容和结果面板
              children: [
                // 主体内容：头像、VS、进度条、属性对比动画
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
                              'You', 
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
                              'Oliver',
                              avatarSize,
                              counterFontSize,
                            ),
                          ],
                        ),
                        SizedBox(height: maxHeight * 0.015),
                        // PK进度条，显示当前胜率
                        PKProgressBar(
                          maxWidth: maxWidth,
                          progressBarWidthFactor: _progressBarWidthFactor,
                        ),
                        SizedBox(height: attributeContainerMargin),
                        // 属性对比动画区域
                        FutureBuilder<Map<String, int>>(
                          future: _fetchPkAttributes(), // 从 Firestore 获取当前用户的属性
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final pkAttributes = snapshot.data!;
                            // 这里将 pkAttributes 作为 leftAttributes 传递给 PKAttributeComparisonContainer
                            return PKAttributeComparisonContainer(
                              parentWidth: maxWidth,
                              onAllAnimationsComplete:
                                  _allAttributeAnimationsDoneNotifier,
                              progressBarWidthFactor: _progressBarWidthFactor,
                              leftAttributes: pkAttributes, // ← 这里传入
                            );
                          },
                        ),
                        SizedBox(height: maxHeight * 0.12),
                      ],
                    ),
                  ),
                ),
                // PK结果面板弹窗，显示胜负结果
                if (_showResultPanel)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.4), // 半透明黑色背景，突出弹窗
                      child: PKResultPanel(
                        winnerText: _winnerText,           // 胜负文字
                        winnerAvatarPath: _winnerAvatarPath, // 胜者头像路径
                        maxWidth: maxWidth,                // 弹窗最大宽度
                        onClose: _closeResultPanel,        // 关闭弹窗回调
                        onRematch: _onRematch,             // 再来一局回调
                        onViewStats: _onViewStats,         // 查看数据回调
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      // 底部导航栏
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
