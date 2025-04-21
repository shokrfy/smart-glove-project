import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const String theRouteName = 'signin';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
            color: Colors.white, // Background set to white
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05), // Top spacing
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        // Handle back button press
                      },
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text color set to black
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter your first name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // Spacing between text fields
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter your last name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter your new password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true, // For password security
                ),
                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  onPressed: () {
                    // Handle Submit button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Button background color set to black
                    fixedSize: Size(screenWidth * 0.8, screenHeight * 0.06),
                  ),
                  child: Text(
                    'Submit application',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.white, // Button text color set to white
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
