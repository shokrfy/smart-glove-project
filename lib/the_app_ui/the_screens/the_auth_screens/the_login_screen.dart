import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String theRouteName = 'login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

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
                SizedBox(height: screenHeight * 0.1),
                // Top spacing
                Row(
                  children: [
                    Image.asset(
                      'lib/the_assets/the_images/Icon sign language.png',
                      // Update the asset path as needed
                      height: screenHeight * 0.08, // Smaller image height
                      width: screenWidth * 0.15, // Smaller image width
                      fit: BoxFit.contain, // Ensures the image scales properly
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    // Space between image and text
                    Text(
                      'Log in to continue',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: Colors.black, // Text color set to black
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email or Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Spacing between text fields
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true, // For password security
                ),
                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  onPressed: () {
                    // Handle Log in button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    // Button background color set to black
                    fixedSize: Size(screenWidth * 0.8, screenHeight * 0.06),
                    //Todo: add the login logic
                  ),
                  child: Text(
                    'Log in',
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