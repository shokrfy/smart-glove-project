import 'package:flutter/material.dart';
import 'package:the_graduation_project/the_app_ui/the_screens/the_pairing_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routeName = '/welcome';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: w * 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.all(w * 0.06),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to Smart Glove',
                  style: TextStyle(
                    fontSize: w * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: h * 0.02),
                Text(
                  'smart glove is your bridge to seamless communication. '
                  'Translate sign language into text and voice effortlessly. '
                  'Begin your journey to break communication barriers.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: w * 0.04),
                ),
                SizedBox(height: h * 0.03),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: h * 0.018),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        PairingScreen.theRouteName,
                      );
                    },
                    child: Text('Start', style: TextStyle(fontSize: w * 0.045)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
