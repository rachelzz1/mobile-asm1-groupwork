// lib/pk_battle_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/pk_progress_bar.dart';
import '../widgets/pk_attribute_comparison.dart';
import '../widgets/pk_result_panel.dart';
import 'home_page.dart';
// No need to import attribute_data.dart here if it's only used by pk_attribute_comparison.dart

class PKBattleScreen extends StatefulWidget {
  const PKBattleScreen({super.key});

  @override
  State<PKBattleScreen> createState() => _PKBattleScreenState();
}

class _PKBattleScreenState extends State<PKBattleScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 2;

  late AnimationController _panelAnimationController;
  late Animation<double> _panelOpacityAnimation;
  final ValueNotifier<bool> _allAttributeAnimationsDoneNotifier = ValueNotifier(
    false,
  );

  // PKBattleScreen now owns and initializes _progressBarWidthFactor
  final ValueNotifier<double> _progressBarWidthFactor = ValueNotifier<double>(
    0.0,
  );

  bool _showResultPanel = false;
  String _winnerText = "";
  String _winnerAvatarPath = "";

  @override
  void initState() {
    super.initState();
    _progressBarWidthFactor.value = 0.0; // Ensure it's reset on init

    _panelAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _panelOpacityAnimation = CurvedAnimation(
      parent: _panelAnimationController,
      curve: Curves.easeInOut,
    );

    _allAttributeAnimationsDoneNotifier.addListener(_handleAllAnimationsDone);
  }

  void _handleAllAnimationsDone() {
    if (_allAttributeAnimationsDoneNotifier.value) {
      final double progress = _progressBarWidthFactor.value;
      if (progress > 0.5001) {
        // Add a small epsilon for floating point comparisons
        _winnerText = "You Win!";
        _winnerAvatarPath = 'assets/images/girl.png';
      } else if (progress < 0.4999) {
        // Add a small epsilon
        _winnerText = "Kris Wins!";
        _winnerAvatarPath = 'assets/images/boy.png';
      } else {
        _winnerText = "It's a Tie!";
        _winnerAvatarPath = '';
      }

      Future.delayed(const Duration(milliseconds: 100), () {
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
    _closeResultPanel(); // Close panel before navigating
    // A short delay can prevent jank if panel closing animation is ongoing
    Future.delayed(
      Duration(
        milliseconds: _panelAnimationController.duration?.inMilliseconds ?? 200,
      ),
      () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const FitnessHomePage()),
          );
        }
      },
    );
  }

  void _onViewStats() {
    _closeResultPanel();
    // Implement navigation or action for View Stats
    print("View Stats Tapped");
  }

  @override
  void dispose() {
    _allAttributeAnimationsDoneNotifier.removeListener(
      _handleAllAnimationsDone,
    );
    _allAttributeAnimationsDoneNotifier.dispose();
    _panelAnimationController.dispose();
    _progressBarWidthFactor.dispose(); // Dispose the notifier
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
    Color color = isActive ? const Color(0xFFFF7A00) : const Color(0xFFBDBDBD);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (mounted) {
            if (index == 0) {
              // Home
              print('Try to jump to FitnessHomePage...');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const FitnessHomePage(),
                ),
              ); // Example: refresh for demo
              print('home');
            }
            // Add navigation logic for other tabs if needed
            // else if (index == 1) { // Calendar }
            // else if (index == 3) { // Profile }

            // If PK tab (index 2) is tapped again while active, and panel is shown, maybe close panel or restart
            if (index == 2 && _currentIndex == 2 && _showResultPanel) {
              _closeResultPanel();
            } else if (index == 2 &&
                _currentIndex == 2 &&
                !_allAttributeAnimationsDoneNotifier.value) {
              // If PK tapped again and animations haven't finished, maybe allow restart?
              // For now, just set state. If PKBattleScreen is current, tapping PK doesn't restart by default.
            }

            setState(() {
              _currentIndex = index;
            });
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

            final double padding = maxWidth * 0.04;
            final double avatarSize = maxWidth * 0.28;
            final double vsFontSize = maxWidth * 0.1;
            final double counterFontSize = maxWidth * 0.09;
            final double attributeContainerMargin = maxHeight * 0.025;

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: maxHeight * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Avatars and VS
                            Column(
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
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4,
                                      ),
                                    ),
                                    child: Container(
                                      width: avatarSize,
                                      height: avatarSize,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/girl.png',
                                          width: avatarSize * 0.8,
                                          height: avatarSize * 0.8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'You',
                                  style: TextStyle(
                                    fontSize: counterFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'VS',
                              style: TextStyle(
                                fontSize: vsFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            Column(
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
                                    width: avatarSize,
                                    height: avatarSize,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/boy.png',
                                        width: avatarSize * 0.8,
                                        height: avatarSize * 0.8,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Kris',
                                  style: TextStyle(
                                    fontSize: counterFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: maxHeight * 0.03),
                        PKProgressBar(
                          // Use the new widget
                          maxWidth: maxWidth,
                          progressBarWidthFactor: _progressBarWidthFactor,
                        ),
                        SizedBox(height: attributeContainerMargin),
                        PKAttributeComparisonContainer(
                          // Use the new widget
                          parentWidth: maxWidth,
                          onAllAnimationsComplete:
                              _allAttributeAnimationsDoneNotifier,
                          progressBarWidthFactor: _progressBarWidthFactor,
                        ),
                        SizedBox(height: maxHeight * 0.15),
                      ],
                    ),
                  ),
                ),
                if (_showResultPanel)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                      child: PKResultPanel(
                        // Use the new widget
                        winnerText: _winnerText,
                        winnerAvatarPath: _winnerAvatarPath,
                        maxWidth:
                            maxWidth, // Pass constraints.maxWidth for panel's internal sizing
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
