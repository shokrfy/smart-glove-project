import 'package:flutter/material.dart';

class GestureCustomizeScreen extends StatefulWidget {
  static const String theRouteName = 'gesture_customize';

  const GestureCustomizeScreen({super.key});

  @override
  State<GestureCustomizeScreen> createState() => _GestureCustomizeScreenState();
}

class _GestureCustomizeScreenState extends State<GestureCustomizeScreen> {
  final List<String> labels = [
    'Hello',
    'Thank you',
    'Yes',
    'No',
    'I need help',
  ];
  String currentLabel = 'Hello';
  bool recording = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign2Speak', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main title
            Text(
              'Sign2Speak',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: screenHeight * 0.04),

            // Add new gesture section
            Text(
              'Add New Gesture',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Recording button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    recording = !recording;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        recording
                            ? '🔴 Recording started for: $currentLabel'
                            : '🟢 Recording stopped',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.8, screenHeight * 0.06),
                  shape: StadiumBorder(),
                ),
                child: Text(
                  recording ? 'Stop Recording' : 'Record Gesture',
                  style: TextStyle(fontSize: screenWidth * 0.045),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.04),

            // Recorded gestures section
            Text(
              'Your Gestures',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // This is the one and only dropdown left:
            Text(
              'Select Label for Gesture:',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            DropdownButton<String>(
              value: currentLabel,
              items:
                  labels.map((label) {
                    return DropdownMenuItem(
                      value: label,
                      child: Text(
                        label,
                        style: TextStyle(fontSize: screenWidth * 0.045),
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  currentLabel = value!;
                });
              },
            ),

            SizedBox(height: screenHeight * 0.02),

            // Gesture list & delete icons (left intact)
            Expanded(
              child: ListView(
                children: [
                  // Example of a saved gesture card:
                  Card(
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: ListTile(
                      title: Text('Gesture: $currentLabel'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Todo: add delete logic
                        },
                      ),
                    ),
                  ),
                  // ...more cards
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
