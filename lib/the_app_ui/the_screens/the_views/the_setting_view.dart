import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const String theRouteName = 'settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = 'English'; // Default language

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings' , style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Reconnect Gloves',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Reconnect your gloves to ensure seamless communication.',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: () {
                  // Todo : Handle Reconnect button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  fixedSize: Size(screenWidth * 0.8, screenHeight * 0.06),
                ),
                child: Text(
                  'Reconnect',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Text(
                'Choose Language',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Select your preferred language for translations.',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField<String>(
                value: selectedLanguage,
                items: ['English', 'Arabic',]
                    .map((language) => DropdownMenuItem(
                  value: language,
                  child: Text(language),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.015,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
