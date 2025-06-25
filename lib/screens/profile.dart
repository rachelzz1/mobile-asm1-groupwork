import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_page.dart';
import 'pk_battle_screen.dart';
import 'calendar.dart';
import 'welcome_screen.dart';
import 'user_details_screen.dart';

// --- 图标资源路径管理类 ---
class AppAssets {
  static const String navHomeIconSVG = 'assets/images/nav_home.svg';
  static const String navCalendarIconSVG = 'assets/images/nav_calendar.svg';
  static const String navPkIconSVG = 'assets/images/nav_pk.svg';
  static const String navProfileIconSVG = 'assets/images/nav_profile.svg';
}

// --- Profile 页面（Stateful） ---
class ProfileScreen extends StatefulWidget {
  final String userId;
  final String username;
  // 构造函数，接收用户ID和用户名
  const ProfileScreen({super.key, required this.userId, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;
  static const Color unselectedColor = Colors.grey;
  static const double iconBottomPadding = 4.0;
  static const double labelFontSize = 12.0;

  // PK 属性初始值
  Map<String, int> _pkAttributes = {
    "endurance": 0,
    "burst": 0,
    "strength": 0,
    "flexibility": 0,
  };

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FitnessHomePage(userId: widget.userId, username: widget.username)),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CalendarPage(userId: widget.userId, username: widget.username)),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PKBattleScreen(userId: widget.userId, username: widget.username)),
        );
        break;
      case 3:
        // 当前页，无需跳转
        break;
    }
  }

  Widget _buildSvgNavIcon({required String assetName, required Color color}) {
    return SvgPicture.asset(
      assetName,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      width: 24,
      height: 24,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchPkAttributes();
  }

  Future<void> _fetchPkAttributes() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    if (doc.exists && doc.data()?['pkAttributes'] != null) {
      setState(() {
        _pkAttributes = Map<String, int>.from(doc.data()!['pkAttributes']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: iconBottomPadding),
              child: _buildSvgNavIcon(
                assetName: AppAssets.navHomeIconSVG,
                color:
                    _selectedIndex == 0
                        ? const Color.fromARGB(255, 255, 152, 0)
                        : unselectedColor,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: iconBottomPadding),
              child: _buildSvgNavIcon(
                assetName: AppAssets.navCalendarIconSVG,
                color:
                    _selectedIndex == 1
                        ? const Color.fromARGB(255, 255, 152, 0)
                        : unselectedColor,
              ),
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: iconBottomPadding),
              child: _buildSvgNavIcon(
                assetName: AppAssets.navPkIconSVG,
                color:
                    _selectedIndex == 2
                        ? const Color.fromARGB(255, 255, 152, 0)
                        : unselectedColor,
              ),
            ),
            label: 'PK',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: iconBottomPadding),
              child: _buildSvgNavIcon(
                assetName: AppAssets.navProfileIconSVG,
                color:
                    _selectedIndex == 3
                        ? const Color.fromARGB(255, 255, 152, 0)
                        : unselectedColor,
              ),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFFF8F4F8),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 255, 152, 0),
        unselectedItemColor: unselectedColor,
        selectedFontSize: labelFontSize,
        unselectedFontSize: labelFontSize,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
  child: Column(
    children: [
      _buildHeader(context),
      const SizedBox(height: 16),
      _buildUserInfo(),
      const SizedBox(height: 24),
      _buildOverallStats(),
      const SizedBox(height: 30),
      _buildPkValueOverview(),
      const SizedBox(height: 30),
      _buildAchievementSection(context),
      const SizedBox(height: 30),

      // ✅ ✅ ✅ 在这里添加按钮 ✅ ✅ ✅
      Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              elevation: 0,
            ),
            child: const Text(
              'Log Out of This Account',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      )
    ],
  ),
),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      color: const Color(0xFFE5F1F9),
      padding: EdgeInsets.only(top: statusBarHeight + 20, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/profile_avatar.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // 👇 使用 InkWell 将 Row 包裹起来，使其可点击
      InkWell(
        // 设置一个圆形的点击波纹效果
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          // 👇 点击时执行页面跳转
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailsScreen(userId: widget.userId),
            ),
          );
        },
        child: Padding(
          // 添加一些内边距，让点击区域更舒适
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // 让 Row 的宽度自适应内容
            children: [
              Text(
                widget.username,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // 这个图标现在是可点击区域的一部分
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        '@83276936 ・ Joined in June 2025',
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE08A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: 'sans-serif',
                ),
                children: const [
                  TextSpan(
                    text: '51 ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: 'Following  '),
                  TextSpan(
                    text: '39 ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: 'Followers'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEBF4FC),
              border: Border.all(color: const Color(0xFFD2E6F8), width: 1.5),
            ),
            child: Icon(
              Icons.person_add_alt_1_outlined,
              color: Colors.blue.shade700,
              size: 20,
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildOverallStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn('60', 'Training\n(days)'),
            const VerticalDivider(thickness: 1, color: Color(0xFFE0E0E0)),
            _buildStatColumn('1.1K', 'Total time\n(minutes)'),
            const VerticalDivider(thickness: 1, color: Color(0xFFE0E0E0)),
            _buildStatColumn('7K', 'Consumption\n(kcal)'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildPkValueOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PK Value Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPkCard(
                  Icons.battery_charging_full,
                  _pkAttributes['endurance'].toString(),
                  'Endurance',
                  const Color(0xFFFFA726),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPkCard(
                  Icons.flash_on,
                  _pkAttributes['burst'].toString(),
                  'Burst',
                  const Color(0xFFFFD600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPkCard(
                  Icons.fitness_center,
                  _pkAttributes['strength'].toString(),
                  'Strength',
                  const Color(0xFFFB8C00),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPkCard(
                  Icons.self_improvement,
                  _pkAttributes['flexibility'].toString(),
                  'Flexibility',
                  const Color(0xFF42A5F5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPkCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Achievement',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AchievementScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    'Show All',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade300,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAchievementImage('assets/images/Reward1.png'),
                _buildAchievementImage('assets/images/Reward5.png'),
                _buildAchievementImage('assets/images/Reward2.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementImage(String imagePath) {
    return Image.asset(imagePath, width: 85, height: 85);
  }
}

// --- 成就列表页面 ---
class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  static final List<Achievement> _achievements = [
    Achievement(id: 1, isEarned: true),
    Achievement(id: 4, isEarned: false),
    Achievement(id: 2, isEarned: true),
    Achievement(id: 5, isEarned: true),
    Achievement(id: 6, isEarned: false),
    Achievement(id: 3, isEarned: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Achievement')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1,
        ),
        itemCount: _achievements.length,
        itemBuilder: (context, index) {
          final achievement = _achievements[index];
          String imagePath;
          if (achievement.isEarned) {
            imagePath = 'assets/images/Reward${achievement.id}.png';
          } else {
            imagePath = 'assets/images/Reward${achievement.id}grey.png';
          }
          return Image.asset(imagePath);
        },
      ),
    );
  }
}

// --- 数据模型类 ---
class Achievement {
  final int id;
  final bool isEarned;
  const Achievement({required this.id, required this.isEarned});
}
