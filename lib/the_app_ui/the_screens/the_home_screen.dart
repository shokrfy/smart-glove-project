import 'package:flutter/material.dart';
import 'package:the_graduation_project/services/speech_to_text_service.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_views/the_geasture_costimize_view.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_views/the_help_view.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_views/the_setting_view.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_views/the_user_account_view.dart';

enum DrawerItem { home, gestureCustomize, help, settings, userAccount }

class HomeScreen extends StatefulWidget {
  static const String theRouteName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechToTextService _speechService = SpeechToTextService();
  bool _isListening = false;
  String _recognizedText = "Tap the mic and speak to convert speech into text";

  DrawerItem selectedDrawerView = DrawerItem.home; // Default selected screen

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title:
              selectedDrawerView == DrawerItem.home
                  ? const Text(
                    'Sign2Speak',
                    style: TextStyle(color: Colors.white), // AppBar text color
                  )
                  : selectedDrawerView == DrawerItem.gestureCustomize
                  ? const Text(
                    'Gesture Customization',
                    style: TextStyle(color: Colors.white),
                  )
                  : selectedDrawerView == DrawerItem.help
                  ? const Text(
                    'Help & Support',
                    style: TextStyle(color: Colors.white),
                  )
                  : selectedDrawerView == DrawerItem.settings
                  ? const Text(
                    'Settings',
                    style: TextStyle(color: Colors.white),
                  )
                  : const Text(
                    'User Account',
                    style: TextStyle(color: Colors.white),
                  ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ), // Drawer icon color
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.black),
                child: const Text(
                  'Sign2Speak',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  setState(() {
                    selectedDrawerView = DrawerItem.home;
                  });
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.back_hand_outlined),
                title: const Text('Gesture Customization'),
                onTap: () {
                  setState(() {
                    selectedDrawerView = DrawerItem.gestureCustomize;
                  });
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & Support'),
                onTap: () {
                  setState(() {
                    selectedDrawerView = DrawerItem.help;
                  });
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  setState(() {
                    selectedDrawerView = DrawerItem.settings;
                  });
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('User Account'),
                onTap: () {
                  setState(() {
                    selectedDrawerView = DrawerItem.userAccount;
                  });
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ],
          ),
        ),
        body: Builder(
          builder: (context) {
            if (selectedDrawerView == DrawerItem.home) {
              return Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  children: [
                    _buildGestureTranslationSection(screenHeight, screenWidth),
                    SizedBox(height: screenHeight * 0.02), // Responsive spacing
                    _buildSpeechToTextSection(screenHeight, screenWidth),
                  ],
                ),
              );
            } else if (selectedDrawerView == DrawerItem.gestureCustomize) {
              return const GestureCustomizeScreen();
            } else if (selectedDrawerView == DrawerItem.help) {
              return const HelpScreen();
            } else if (selectedDrawerView == DrawerItem.settings) {
              return const SettingsScreen();
            } else if (selectedDrawerView == DrawerItem.userAccount) {
              return const UserAccountScreen();
            } else {
              return const Center(child: Text('Unknown View'));
            }
          },
        ),
      ),
    );
  }

  void _handleSpeak() async {
    if (_isListening) {
      await _speechService.stopListening();
      setState(() {
        _isListening = false;
      });
    } else {
      setState(() {
        _recognizedText = "Listening...";
        _isListening = true;
      });

      await _speechService.startListening((resultText) {
        setState(() {
          _recognizedText = resultText;
          _isListening = false;
        });
      });
    }
  }

  Widget _buildGestureTranslationSection(
    double screenHeight,
    double screenWidth,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.pan_tool, size: screenWidth * 0.1),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'Gesture Translation',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              height: screenHeight * 0.15,
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  //Todo: add the logic of the gesture translation
                  'Translated Text',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: () {
                // Handle "Sign" button press
              },
              child: Text(
                'Sign',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeechToTextSection(double screenHeight, double screenWidth) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.mic, size: screenWidth * 0.1),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'Speech-to-Text',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              height: screenHeight * 0.15,
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  _recognizedText,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: _handleSpeak,
              child: Text(
                _isListening ? 'Stop' : 'Speak',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
