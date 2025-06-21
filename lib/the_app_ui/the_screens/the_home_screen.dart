import 'package:flutter/material.dart';
import 'package:the_graduation_project/services/ai_service.dart'; // NEW
import 'package:the_graduation_project/services/ble_service.dart';
import 'package:the_graduation_project/services/speech_to_text_service.dart';
import 'package:the_graduation_project/services/text_to_speech_service.dart';
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
  final TextToSpeechService _ttsService = TextToSpeechService();
  final BleService _bleService = BleService();

  bool _isListening = false;
  String _recognizedText = 'Tap the mic and speak to convert speech into text';
  String _translatedText = 'Translated Text';

  DrawerItem selectedDrawerView = DrawerItem.home;

  @override
  void initState() {
    super.initState();

    // 1) load your AI model right away
    AIService().loadModel();

    // 2) register for AI predictions
    _bleService.setOnGestureReceivedCallback((gesture) {
      setState(() => _translatedText = gesture);
    });

    // 3) start BLE scan/connect
    _initBle();
  }

  void _initBle() async {
    _bleService.startScan((device) async {
      await _bleService.connectToDevice(device);
      await _bleService.listenToData((data) {
        // raw data: you can still inspect or log if you want
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: selectedDrawerView == DrawerItem.home
              ? const Text('Smart Glove', style: TextStyle(color: Colors.white))
              : selectedDrawerView == DrawerItem.gestureCustomize
                  ? const Text('Gesture Customization',
                      style: TextStyle(color: Colors.white))
                  : selectedDrawerView == DrawerItem.help
                      ? const Text('Help & Support',
                          style: TextStyle(color: Colors.white))
                      : selectedDrawerView == DrawerItem.settings
                          ? const Text('Settings',
                              style: TextStyle(color: Colors.white))
                          : const Text('User Account',
                              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                color: Colors.black,
                height: 100,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Smart Glove',
                      style: TextStyle(color: Colors.white, fontSize: 24)),
                ),
              ),
              for (var item in DrawerItem.values)
                ListTile(
                  leading: _drawerIcon(item),
                  title: Text(_drawerLabel(item)),
                  onTap: () {
                    setState(() => selectedDrawerView = item);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
        body: Builder(
          builder: (context) {
            if (selectedDrawerView == DrawerItem.home) {
              return Padding(
                padding: EdgeInsets.all(w * 0.04),
                child: Column(
                  children: [
                    _buildGestureTranslationSection(h, w),
                    SizedBox(height: h * 0.02),
                    _buildSpeechToTextSection(h, w),
                  ],
                ),
              );
            } else if (selectedDrawerView == DrawerItem.gestureCustomize) {
              return const GestureCustomizeScreen();
            } else if (selectedDrawerView == DrawerItem.help) {
              return const HelpScreen();
            } else if (selectedDrawerView == DrawerItem.settings) {
              return const SettingsScreen();
            } else {
              return const UserAccountScreen();
            }
          },
        ),
      ),
    );
  }

  Widget _buildGestureTranslationSection(double h, double w) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.pan_tool, size: w * 0.1),
                SizedBox(width: w * 0.02),
                Text('Gesture Translation',
                    style: TextStyle(
                        fontSize: w * 0.05, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: h * 0.02),
            Container(
              height: h * 0.15,
              color: Colors.grey[200],
              child: Center(
                child: Text(_translatedText,
                    style: TextStyle(fontSize: w * 0.05, color: Colors.black)),
              ),
            ),
            SizedBox(height: h * 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: w * 0.045),
              ),
              onPressed: () async {
                await _ttsService.speak(_translatedText);
              },
              child: const Text('listen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeechToTextSection(double h, double w) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.mic, size: w * 0.1),
                SizedBox(width: w * 0.02),
                Text('Speech-to-Text',
                    style: TextStyle(
                        fontSize: w * 0.05, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: h * 0.02),
            Container(
              height: h * 0.15,
              color: Colors.grey[200],
              child: Center(
                child: Text(_recognizedText,
                    style: TextStyle(fontSize: w * 0.05, color: Colors.black)),
              ),
            ),
            SizedBox(height: h * 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: w * 0.045),
              ),
              onPressed: _handleSpeak,
              child: Text(_isListening ? 'Stop' : 'Speak'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSpeak() async {
    if (_isListening) {
      await _speechService.stopListening();
      setState(() => _isListening = false);
    } else {
      setState(() {
        _recognizedText = 'Listening...';
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

  Icon _drawerIcon(DrawerItem item) {
    switch (item) {
      case DrawerItem.home:
        return const Icon(Icons.home);
      case DrawerItem.gestureCustomize:
        return const Icon(Icons.back_hand_outlined);
      case DrawerItem.help:
        return const Icon(Icons.help);
      case DrawerItem.settings:
        return const Icon(Icons.settings);
      case DrawerItem.userAccount:
        return const Icon(Icons.account_circle);
    }
  }

  String _drawerLabel(DrawerItem item) {
    switch (item) {
      case DrawerItem.home:
        return 'Home';
      case DrawerItem.gestureCustomize:
        return 'Gesture Customization';
      case DrawerItem.help:
        return 'Help & Support';
      case DrawerItem.settings:
        return 'Settings';
      case DrawerItem.userAccount:
        return 'User Account';
    }
  }
}
