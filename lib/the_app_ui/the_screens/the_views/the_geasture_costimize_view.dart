import 'package:flutter/material.dart';

class GestureCustomizeScreen extends StatefulWidget {
  static const String theRouteName = 'gesture_customize';

  const GestureCustomizeScreen({super.key});

  @override
  State<GestureCustomizeScreen> createState() => _GestureCustomizeScreenState();
}

class _GestureCustomizeScreenState extends State<GestureCustomizeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign2Speak',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Add New Gesture',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: () {
                // Todo : add the record gesture logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                fixedSize: Size(screenWidth * 0.8, screenHeight * 0.06),
              ),
              child: Text(
                'Record Gesture',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Text(
              'Your Gestures',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView(
                children: [
                  // Todo : display the list of gestures logic
                  _buildGestureItem(
                    screenWidth,
                    screenHeight,
                    'Hello Gesture',
                    'Wave hand to say hello',
                  ),
                  _buildGestureItem(
                    screenWidth,
                    screenHeight,
                    'Thank You Gesture',
                    'Bring hand to chest',
                  ),
                  _buildGestureItem(
                    screenWidth,
                    screenHeight,
                    'Goodbye Gesture',
                    'Wave hand to say goodbye',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGestureItem(
      double screenWidth, double screenHeight, String title, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: () {
                    // Todo : add the edit gesture logic
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Todo : add the delete gesture logic
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
