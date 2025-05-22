import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/app_assets.dart';
import '../widgets/profile_drawer.dart';
import '../widgets/workout_card.dart';
import '../screens/pk_battle_screen.dart';

class FitnessHomePage extends StatefulWidget {
  const FitnessHomePage({super.key});

  @override
  State<FitnessHomePage> createState() => _FitnessHomePageState();
}

class _FitnessHomePageState extends State<FitnessHomePage> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;

  final List<String> _hotSearches = [
    "Full Body Workout",
    "Abs Challenge",
    "Yoga for Beginners",
    "HIIT Cardio",
    "Leg Day Burn",
  ];

  final GlobalKey _searchBarKey = GlobalKey();
  double _suggestionsTopOffset = 0;
  final double _pageHorizontalPadding = 20.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex == index && index != 0) {
      // If want to pop to the first route of a tab if it's tapped again:
      // Navigator.popUntil(context, (route) => route.isFirst);
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Home
        if (ModalRoute.of(context)?.settings.name != '/') {
          // A simple check if not root
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const FitnessHomePage(),
            ), // Go to home
            (Route<dynamic> route) => false, // Remove all previous routes
          );
        }
        break;
      case 1: // Calendar
        //Navigator.push(
        //context,
        //MaterialPageRoute(builder: (context) => const CalendarPage()),
        //);
        break;
      case 2: // PK
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PKBattleScreen()),
        );
        break;
      case 3: // Profile
        // Option 1: Open Drawer (if Profile tab is just for drawer)
        // _scaffoldKey.currentState?.openDrawer();

        // Option 2: Navigate to a dedicated Profile Page

        //Navigator.push(
        //context,
        //MaterialPageRoute(builder: (context) => const ProfileSummaryPage()),
        //);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateSuggestionsPosition();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChange);
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchFocusChange() {
    if (mounted) {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
      if (_isSearchFocused) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _updateSuggestionsPosition();
        });
      }
    }
  }

  void _updateSuggestionsPosition() {
    if (_searchBarKey.currentContext != null && mounted) {
      final RenderBox renderBox =
          _searchBarKey.currentContext!.findRenderObject() as RenderBox;
      final Offset globalPosition = renderBox.localToGlobal(Offset.zero);
      final screenPadding = MediaQuery.of(context).padding;
      setState(() {
        _suggestionsTopOffset =
            globalPosition.dy + renderBox.size.height - screenPadding.top;
      });
    }
  }

  void _onHotSearchTap(String searchTerm) {
    _searchController.text = searchTerm;
    _searchFocusNode.unfocus();
  }

  Widget _buildSearchBar() {
    return Container(
      key: _searchBarKey,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius:
            _isSearchFocused
                ? const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )
                : BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Colors.black54),
          hintText: "Search for today's tasks...",
          hintStyle: TextStyle(color: Colors.black45),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildHotSearchesList() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _isSearchFocused ? (_hotSearches.length * 40.0) + 10 : 0,
      width: MediaQuery.of(context).size.width - (_pageHorizontalPadding * 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow:
            _isSearchFocused
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ]
                : [],
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _isSearchFocused ? 1.0 : 0.0,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child:
              _isSearchFocused
                  ? ListView.builder(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    itemCount: _hotSearches.length,
                    itemBuilder: (context, index) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _onHotSearchTap(_hotSearches[index]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _hotSearches[index],
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                  : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildSvgNavIcon({
    required String assetName,
    required Color color,
    double size = 26.0,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        assetName,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        placeholderBuilder:
            (BuildContext context) =>
                Icon(Icons.error_outline, size: size, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color unselectedColor = Colors.grey[600]!;
    const Color selectedColor = Colors.orange;
    const double labelFontSize = 12.0;
    const double iconBottomPadding = 4.0;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const ProfileDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                _pageHorizontalPadding,
                _pageHorizontalPadding,
                _pageHorizontalPadding,
                _pageHorizontalPadding + 70,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi Kris',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Feeling ready for today's\nlittle challenge?",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () => _scaffoldKey.currentState?.openDrawer(),
                        customBorder: const CircleBorder(),
                        child: Container(
                          padding: const EdgeInsets.all(1.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1.5),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: const AssetImage(
                              AppAssets.profileImageAsset,
                            ),
                            onBackgroundImageError: (e, s) {},
                            child: ClipOval(
                              child: Image.asset(
                                AppAssets.profileImageAsset,
                                fit: BoxFit.cover,
                                width: 70,
                                height: 70,
                                errorBuilder:
                                    (c, e, s) => Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.person,
                                        size: 35,
                                        color: Colors.white70,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  _buildSearchBar(),
                  const SizedBox(height: 25),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.74,
                    children: [
                      WorkoutCard(
                        title: "Boom Burpee\nBurn",
                        duration: 8,
                        calories: "80-140",
                        characterImagePath: AppAssets.burpeeCharAsset,
                        backgroundImagePath: AppAssets.burpeeBgAsset,
                        backgroundColor: Colors.orange.shade300,
                        characterImageHeight: 95,
                        workoutIdentifier: "boom_burpee_burn",
                      ),
                      WorkoutCard(
                        title: "Sour and\nRefreshing\nSlim Belly",
                        duration: 12,
                        calories: "76-114",
                        characterImagePath: AppAssets.slimBellyCharAsset,
                        backgroundImagePath: AppAssets.slimBellyBgAsset,
                        backgroundColor: Colors.lightBlue.shade200,
                        characterImageHeight: 105,
                        workoutIdentifier: "slim_belly_yoga",
                      ),
                      WorkoutCard(
                        title: "Groovy\nDance Fit",
                        duration: 15,
                        calories: "100-130",
                        characterImagePath: AppAssets.danceFitCharAsset,
                        backgroundImagePath: AppAssets.danceFitBgAsset,
                        backgroundColor: Colors.yellow.shade600,
                        characterImageHeight: 95,
                        workoutIdentifier: "groovy_dance_fit",
                      ),
                      WorkoutCard(
                        title: "Plank\nWorkout",
                        duration: 5,
                        calories: "20-50",
                        characterImagePath: AppAssets.plankCharAsset,
                        backgroundImagePath: AppAssets.plankBgAsset,
                        backgroundColor: Colors.deepOrange.shade400,
                        characterImageHeight: 93,
                        workoutIdentifier: "plank_challenge",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isSearchFocused && _suggestionsTopOffset > 0)
              Positioned(
                top: _suggestionsTopOffset,
                left: _pageHorizontalPadding,
                child: _buildHotSearchesList(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: iconBottomPadding),
              child: _buildSvgNavIcon(
                assetName: AppAssets.navHomeIconSVG,
                color: _selectedIndex == 0 ? selectedColor : unselectedColor,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: iconBottomPadding),
              child: _buildSvgNavIcon(
                assetName: AppAssets.navCalendarIconSVG,
                color: _selectedIndex == 1 ? selectedColor : unselectedColor,
              ),
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: iconBottomPadding),
              child: _buildSvgNavIcon(
                assetName: AppAssets.navPkIconSVG,
                color: _selectedIndex == 2 ? selectedColor : unselectedColor,
              ),
            ),
            label: 'PK',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: iconBottomPadding),
              child: _buildSvgNavIcon(
                assetName: AppAssets.navProfileIconSVG,
                color: _selectedIndex == 3 ? selectedColor : unselectedColor,
              ),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFFF8F4F8),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        selectedFontSize: labelFontSize,
        unselectedFontSize: labelFontSize,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0.0,
      ),
    );
  }
}
