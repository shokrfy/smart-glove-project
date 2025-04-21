import 'package:flutter/material.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_auth_screens/the_auth_screen.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_auth_screens/the_login_screen.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_auth_screens/the_signin_screen.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_home_screen.dart';
// Simport 'package:the_graduation_project/the_app_ui/the_screens/the_pairing_screen.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_splash_screen.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_views/the_geasture_costimize_view.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_views/the_help_view.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_views/the_setting_view.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_views/the_user_account_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        HomeScreen.theRouteName: (context) => HomeScreen(),
        TheSplashScreen.theRoutName: (context) => const TheSplashScreen(),
        AuthScreen.theRouteName: (context) => const AuthScreen(),
        LoginScreen.theRouteName: (context) => const LoginScreen(),
        SignInScreen.theRouteName: (context) => const SignInScreen(),
        GestureCustomizeScreen.theRouteName:
            (context) => GestureCustomizeScreen(),
        HelpScreen.theRouteName: (context) => HelpScreen(),
        SettingsScreen.theRouteName: (context) => SettingsScreen(),
        UserAccountScreen.theRouteName: (context) => UserAccountScreen(),
        // PairingScreen.theRouteName: (context) => PairingScreen(),
      },
    );
  }
}
