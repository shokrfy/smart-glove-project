import 'package:flutter/material.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/welcome_screen.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_splash_screen.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_pairing_screen.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_home_screen.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_auth_screens/the_auth_screen.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_auth_screens/the_login_screen.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_auth_screens/the_signin_screen.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_views/the_geasture_costimize_view.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_views/the_help_view.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_views/the_setting_view.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_views/the_user_account_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Glove',
      theme: ThemeData(primarySwatch: Colors.blue),

      // تظهر أولاً شاشة الترحيب
      initialRoute:TheSplashScreen.theRoutName,

      routes: {
        // شاشة الترحيب
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        // شاشة الـ Splash برابط "/splash"
        TheSplashScreen.theRoutName: (context) => const TheSplashScreen(),
        // شاشة الاقتران
        PairingScreen.theRouteName: (context) => const PairingScreen(),
        // الشاشة الرئيسية
        HomeScreen.theRouteName: (context) => const HomeScreen(),
        // شاشات المصادقة
        AuthScreen.theRouteName: (context) => const AuthScreen(),
        LoginScreen.theRouteName: (context) => const LoginScreen(),
        SignInScreen.theRouteName: (context) => const SignInScreen(),
        // باقي الشاشات
        GestureCustomizeScreen.theRouteName:
            (context) => const GestureCustomizeScreen(),
        HelpScreen.theRouteName: (context) => const HelpScreen(),
        SettingsScreen.theRouteName: (context) => const SettingsScreen(),
        UserAccountScreen.theRouteName: (context) => const UserAccountScreen(),
      },
    );
  }
}
