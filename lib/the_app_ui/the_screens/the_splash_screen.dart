import 'package:flutter/material.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/welcome_screen.dart';
import '../../the_app_utilizations/the_app_assets.dart';

class TheSplashScreen extends StatelessWidget {
  // غيرنا القيمة من "/" إلى "/splash"
  static const String theRoutName = '/splash';

  const TheSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
    });

    return Scaffold(
      body: Center(child: Image.asset(TheAssets.theSplashScreen)),
    );
  }
}
