import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'home_page.dart';
import 'pk_battle_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final Set<int> undoneDays = {2, 7, 8, 13, 19, 20, 21, 24};
  final int today = 27;
  final Set<int> future = {28, 29, 30};

  final storage = GetStorage();
  bool isWorkoutDone = false;
  bool isWorkoutGo = false;

  int _currentIndex = 1;
  static const Color themeOrange = Color(0xFFFFBA3A);

  @override
  void initState() {
    super.initState();
    final Donevalue = storage.read('isDone') ?? false;
    final Govalue = storage.read('isGo') ?? false;
    setState(() {
      isWorkoutDone = Donevalue;
      isWorkoutGo = Govalue;
    });
  }

  void _onNavTapped(int index) {
    if (index == _currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FitnessHomePage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PKBattleScreen()),
      );
    } else if (index == 3) {
      // 替换为你的 Profile 页面
      print("Go to Profile");
    }
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    final bool isActive = _currentIndex == index;
    final Color color = isActive ? themeOrange : const Color(0xFFBDBDBD);
    final double iconSize = MediaQuery.of(context).size.width * 0.06;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onNavTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: iconSize,
              height: iconSize,
              color: color,
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/calendar.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'JUNE 2025',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD07A),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statBox('18', 'day', 'TRAINING'),
                    _verticalDivider(),
                    _statBox('720', 'min', 'TOTAL TIME'),
                    _verticalDivider(),
                    _statBox('4.3K', 'kcal', 'CONSUMPTION'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _calendarView(),
              const SizedBox(height: 24),
              const Text(
                'JUNE 27TH (TODAY)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              _workoutTile(
                "Sour and Refreshing Slim Belly",
                isWorkoutDone
                    ? const Color.fromARGB(255, 102, 212, 106)
                    : isWorkoutGo
                    ? Color.fromARGB(255, 255, 218, 118)
                    : Colors.grey[300]!,
                'assets/images/slim_belly_char.png',
              ),
              _workoutTile(
                "Boom Burpee Burn",
                Colors.grey[300]!,
                'assets/images/burpee_char.png',
              ),
              _workoutTile(
                "Plank Workout",
                Colors.grey[300]!,
                'assets/images/plank_char.png',
              ),
              _workoutTile(
                "Groovy Dance Fit",
                Colors.grey[300]!,
                'assets/images/dance_fit_char.png',
              ),
            ],
          ),
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
          children: [
            _buildNavItem('assets/icons/home.svg', 'Home', 0),
            _buildNavItem('assets/icons/calendar.svg', 'Calendar', 1),
            _buildNavItem('assets/icons/PK.svg', 'PK', 2),
            _buildNavItem('assets/icons/profile.svg', 'Profile', 3),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String value, String unit, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(unit, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _verticalDivider() =>
      Container(width: 1, height: 60, color: Colors.grey);

  Widget _calendarView() {
    final weekDays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE6FF),
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage(
            'https://your-background-image-url.com/image.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                weekDays
                    .map(
                      (e) => Text(
                        e,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 12),
          ...List.generate(5, (week) => _calendarRow(week)),
        ],
      ),
    );
  }

  Widget _calendarRow(int weekIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (day) {
        final dateNum = weekIndex * 7 + day + 1;
        if (dateNum > 30) return _dayCell();
        return _dayCell(
          day: "$dateNum",
          isGray: undoneDays.contains(dateNum),
          isGrayforFuture: future.contains(dateNum),
          isBlue: dateNum == today,
        );
      }),
    );
  }

  Widget _dayCell({
    String? day,
    bool isGray = false,
    bool isGrayforFuture = false,
    bool isBlue = false,
  }) {
    return SizedBox(
      width: 40,
      child: Column(
        children: [
          if (day != null)
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isBlue
                            ? const Color(0xFF5BB3FF)
                            : isGray
                            ? const Color(0xFFEDEDED)
                            : isGrayforFuture
                            ? const Color(0xFFEDEDED)
                            : const Color(0xFFFCE313),
                  ),
                ),
                if (!isGrayforFuture)
                  if (isBlue)
                    Image.asset(
                      'assets/images/calendar_today.png',
                      width: 25,
                      height: 25,
                    )
                  else if (isGray)
                    Image.asset(
                      'assets/images/calendar_undone.png',
                      width: 25,
                      height: 25,
                    )
                  else
                    Image.asset(
                      'assets/images/calendar_done.png',
                      width: 25,
                      height: 25,
                    ),
              ],
            )
          else
            const SizedBox(height: 28),
          const SizedBox(height: 4),
          if (day != null)
            Text(day, style: const TextStyle(fontSize: 12))
          else
            const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _workoutTile(String name, Color bgColor, String iconPath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            child: Image.asset(
              iconPath,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
