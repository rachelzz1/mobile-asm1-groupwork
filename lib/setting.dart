// setting.dart
// setting
import 'package:flutter/material.dart';
import 'account_Security_page.dart'; // Updated to use a relative path
import 'language_page.dart';
import 'notifications_page.dart';
import 'appearance_page.dart';
import 'support_page.dart';
import 'widgets/profile_drawer.dart';
import '/screens/home_page.dart'; // Updated to use a relative path

// SettingsPage is the main settings page of the application
class SettingsPage extends StatelessWidget {
  final String userId;
  final String username;

  const SettingsPage({
    Key? key,
    required this.userId,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold implements the basic Material Design visual layout structure
    return Scaffold(
      // AppBar is typically used to display titles, navigation icons, and actions
      appBar: AppBar(
        // leading is the widget on the left side of the AppBar, usually a back button
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, // Back arrow icon
            color: Colors.black, // Icon color set to black
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FitnessHomePage(
                  userId: userId, // 使用传入的userId
                  username: username, // 使用传入的username
                ),
              ),
            );
          },
        ),
        // title is the primary content of the AppBar, usually the page title
        title: const Text(
          'Setting', // Page title
          style: TextStyle(
            color: Colors.black,
          ), // Title text color set to black
        ),
        // elevation sets the shadow depth below the AppBar; 0 means no shadow
        elevation: 0,
        // backgroundColor sets the AppBar's background color to white, matching the design image
        backgroundColor: Colors.white,
      ),
      // body is the primary content area of the Scaffold
      body: SingleChildScrollView(
        // SingleChildScrollView allows its child content to be scrolled if needed, preventing overflow errors
        child: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ), // Adds 16 pixels of padding around the main content
          child: Column(
            // Column arranges its children widgets vertically
            crossAxisAlignment:
                CrossAxisAlignment
                    .start, // Aligns children to the start (left) on the cross-axis (horizontal)
            children: [
              // Welcome/Info Card area
              Container(
                padding: const EdgeInsets.all(
                  16.0,
                ), // Inner padding for the card
                decoration: BoxDecoration(
                  color: const Color(
                    0x52E9D2A6,
                  ), // Card background color set to #F5DFB6
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ), // Card border radius for rounded corners
                ),
                child: Row(
                  // Row arranges its children widgets horizontally
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start, // Aligns children to the start (top) on the cross-axis (vertical)
                  children: [
                    // Your custom user avatar PNG image
                    ClipRRect(
                      // ClipRRect clips its child to a rounded rectangle
                      borderRadius: BorderRadius.circular(
                        40.0,
                      ), // Border radius to make an 80x80 image circular
                      child: Image.asset(
                        'assets/images/avatar.png', // <-- Your user avatar PNG image path
                        width: 80, // Image width
                        height: 80, // Image height
                        fit:
                            BoxFit
                                .cover, // Image fit mode, covers the area and crops overflow
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ), // Adds 16 pixels of horizontal space between image and text
                    Expanded(
                      // Expanded makes its child widget fill all available horizontal space in the Row
                      child: Text(
                        'Hi, Kris, you can personalize the page settings. If you have any questions, please contact us for support.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ), // Text style
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24.0,
              ), // Adds 24 pixels of vertical space between the card and setting options
              // Setting options list using custom PNG icons
              _buildSettingOption(
                context,
                'assets/images/account-settings.png', // Account Security icon path
                'Account Security',
                // On-tap navigation for Account Security
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountSecurityPage(),
                    ),
                  );
                },
              ),
              _buildSettingOption(
                context,
                'assets/images/SVGRepo_iconCarrier.png', // Language icon path
                'Language',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LanguagePage(),
                    ), // <--- NEW NAVIGATION TO LanguagePage
                  );
                },
              ),
              _buildSettingOption(
                context,
                'assets/images/notification.png', // Notifications icon path
                'Notifications',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsPage(),
                    ), // <--- NEW NAVIGATION TO NotificationsPage
                  );
                },
              ),
              _buildSettingOption(
                context,
                'assets/images/SVGRepo.png', // Appearance icon path
                'Appearance',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppearancePage(),
                    ), // <--- NEW NAVIGATION TO AppearancePage
                  );
                },
              ),
              _buildSettingOption(
                context,
                'assets/images/support-svgrepo-com 1.png', // Support icon path
                'Support',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SupportPage(),
                    ), // <--- NEW NAVIGATION TO SupportPage
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _buildSettingOption is a helper function to build a single setting option ListTile.
  // It accepts BuildContext, the asset path for the icon, the option title, and an onTap callback.
  Widget _buildSettingOption(
    BuildContext context,
    String iconAssetPath,
    String title,
    VoidCallback
    onTap, // <--- This parameter is crucial and correctly defined here
  ) {
    return Column(
      children: [
        ListTile(
          // leading is the widget on the left side of the ListTile, here we place the custom icon
          leading: Image.asset(
            iconAssetPath, // Asset path for the icon
            width: 24, // Icon width
            height: 24, // Icon height
            // If your PNG icons are monochrome and you want to tint their color, uncomment the line below:
            // color: Colors.black54, // E.g., to tint the icon to dark grey
          ),
          // title is the primary text content of the ListTile
          title: Text(
            title, // Option title
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ), // Title text style
          ),
          // trailing is the widget on the right side of the ListTile, here we place a forward arrow icon
          trailing: const Icon(
            Icons.arrow_forward_ios, // Forward arrow icon
            size: 16, // Icon size
            color: Colors.grey, // Icon color set to grey
          ),
          // onTap is the callback function that is called when the ListTile is tapped
          onTap: onTap, // <--- The onTap callback is correctly passed here
        ),
        // Divider adds a thin line between each ListTile, providing visual separation
        const Divider(
          height: 1, // Divider height set to 1 pixel
          indent: 16, // Left indentation of the divider by 16 pixels
          endIndent: 16, // Right indentation of the divider by 16 pixels
        ),
      ],
    );
  }
}

// main function is the entry point of the Flutter application
void main() {
  runApp(const MyApp()); // Runs the MyApp widget
}

// MyApp is the root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp is a convenient widget that wraps many widgets needed for Material Design apps
    return MaterialApp(
      title:
          'Settings Demo', // Application title, displayed in the task switcher
      theme: ThemeData(
        primarySwatch:
            Colors
                .blue, // Defines the overall primary color swatch for the application
        visualDensity:
            VisualDensity
                .adaptivePlatformDensity, // Adapts the visual density to the platform
      ),
      home: SettingsPage(
        userId: 'yourUserId', // 这里可以替换为实际的userId
        username: 'yourUsername', // 这里可以替换为实际的username
      ),
    );
  }
}
