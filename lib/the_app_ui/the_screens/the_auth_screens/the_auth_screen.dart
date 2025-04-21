import 'package:flutter/material.dart';

import '../../../the_app_utilizations/the_app_assets.dart';

class AuthScreen extends StatefulWidget {
  static const String theRouteName = 'auth';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.white, // Background color set to white
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.1), // Top spacing
                Text(
                  'SignVoice',
                  style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Title color set to black for contrast
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Translate sign language to spoken language',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.black, // Subtitle color set to black
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.05),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Image.asset(
                          TheAssets.theAuthScreen,
                          height: screenHeight * 0.35, // Larger image height
                          width: screenWidth * 2,   // Larger image width
                          fit: BoxFit.contain,       // Ensures the image scales well
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.05),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle Log in button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Button background color set to black
                        fixedSize: Size(screenWidth * 0.4, screenHeight * 0.06),
                        //Todo: add the navigation to the log in
                      ),
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.white, // Button text color set to white
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Sign up button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Button background color set to black
                        fixedSize: Size(screenWidth * 0.4, screenHeight * 0.06),
                        //Todo: add the navigation to the sign up
                      ),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.white, // Button text color set to white
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05), // Bottom spacing
              ],
            ),
          ),
        ],
      ),
    );
  }
}
