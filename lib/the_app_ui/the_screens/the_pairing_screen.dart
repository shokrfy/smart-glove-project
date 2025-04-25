import 'package:flutter/material.dart';
import 'package:the_graduation_project/services/ble_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'dart:io' show Platform;
import 'dart:convert';

final Logger _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 0,
    lineLength: 0,
    colors: false,
    printEmojis: false,
    dateTimeFormat: DateTimeFormat.none,
  ),
);

class PairingScreen extends StatefulWidget {
  static const String theRouteName = 'pairing';

  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  final BleService bleService = BleService();
  bool _isPairing = false;
  bool _isConnected = false;

  Future<bool> _ensureBlePermissions() async {
    if (Platform.isAndroid) {
      final permissions = [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
        Permission.locationWhenInUse,
      ];

      bool allGranted = true;
      for (final permission in permissions) {
        final status = await permission.status;
        if (!status.isGranted) {
          final result = await permission.request();
          if (!result.isGranted) allGranted = false;
        }
      }
      return allGranted;
    }
    return true;
  }

  Future<void> _startPairing() async {
    final hasPermission = await _ensureBlePermissions();
    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bluetooth permission denied')),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isPairing = true);
    _logger.i('📡 Starting scan for ESP (MAC: 08:D1:F9:CC:16:3E)');

    bleService.startScan((device) async {
      final id = device.remoteId.str;
      _logger.i('📡 Device found: $id, connecting...');
      await bleService.connectToDevice(device);
      _logger.i('🎉 Connected to device: $id');

      await bleService.listenToData((data) {
        final message = utf8.decode(data);
        _logger.i('📨 Data from ESP: $message');
      });

      if (!mounted) return;
      setState(() {
        _isPairing = false;
        _isConnected = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Glove', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 2,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'Pair Gloves',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.015),
            Text(
              'Pair Your Gloves',
              style: TextStyle(
                fontSize: screenWidth * 0.065,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Follow the instructions below to connect your sign language gloves via Bluetooth.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: screenHeight * 0.025),
            InstructionRow(
              icon: Icons.bluetooth,
              text: 'Turn on Bluetooth on your device and your gloves.',
            ),
            InstructionRow(
              icon: Icons.search,
              text: 'Ensure your gloves are in pairing mode.',
            ),
            InstructionRow(
              icon: Icons.check_circle,
              text: "Press 'Start Pairing' to begin the connection.",
            ),
            SizedBox(height: screenHeight * 0.05),
            ElevatedButton(
              onPressed: _isConnected || _isPairing ? null : _startPairing,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                fixedSize: Size(screenWidth * 0.8, screenHeight * 0.06),
                disabledBackgroundColor: Colors.black,
                disabledForegroundColor: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isConnected
                        ? 'Connected'
                        : _isPairing
                        ? 'Pairing...'
                        : 'Start Pairing',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.white,
                    ),
                  ),
                  if (_isPairing) ...[
                    const SizedBox(width: 10),
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
          ],
        ),
      ),
    );
  }
}

class InstructionRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InstructionRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.042,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
