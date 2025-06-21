import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';
import 'package:the_graduation_project/services/ai_service.dart';

final Logger _logger = Logger();

class BleService {
  static const String targetDeviceId = 'A0:DD:6C:0F:EF:24';
  static final Guid serviceUuid =
      Guid.parse('4fafc201-1fb5-459e-8fcc-c5c9c331914b')!;
  static final Guid charUuid =
      Guid.parse('beb5483e-36e1-4688-b7f5-ea07361b26a8')!;

  BluetoothDevice? connectedDevice;
  bool _isConnected = false;

  // ─── AI WIRING ─────────────────────────────────────────────────────────────
  final AIService _aiService = AIService();
  Function(String)? onGestureReceived;

  /// HomeScreen must call this once to receive AI predictions
  void setOnGestureReceivedCallback(Function(String) cb) {
    onGestureReceived = cb;
  }
  // ────────────────────────────────────────────────────────────────────────────

  void startScan(Function(BluetoothDevice) onDeviceFound) {
    _logger.i('📡 Starting scan for target MAC: $targetDeviceId');
    FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
      androidScanMode: AndroidScanMode.balanced,
    );

    FlutterBluePlus.scanResults.listen((results) {
      for (var r in results) {
        final name = r.device.platformName;
        _logger.i('🔍 Found device: $name (RSSI: ${r.rssi})');
        if (!_isConnected && name == 'ESP32_Glove') {
          _isConnected = true;
          FlutterBluePlus.stopScan();
          _logger.i('✅ Target device found: $name');
          onDeviceFound(r.device);
          break;
        }
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    _logger.i('🔗 Connecting to: ${device.remoteId.str}');
    await device.connect(autoConnect: false);
    connectedDevice = device;
    _logger.i('✅ Connected to: ${device.remoteId.str}');
  }

  Future<void> listenToData(Function(List<int>) onDataReceived) async {
    if (connectedDevice == null) return;

    // ─── Ensure AI model is loaded once ───────────────────────────────────────
    await _aiService.loadModel();
    _logger.i('🤖 AI model loaded');
    // ─────────────────────────────────────────────────────────────────────────

    _logger.i('🔍 Discovering services...');
    final services = await connectedDevice!.discoverServices();

    for (var svc in services) {
      _logger.i('🔧 Service: ${svc.uuid}');
      if (svc.uuid == serviceUuid) {
        for (var chr in svc.characteristics) {
          if (chr.uuid == charUuid) {
            _logger.i('🔔 Subscribing to characteristic: $charUuid');
            await chr.setNotifyValue(true);

            // initial read
            try {
              final initial = await chr.read();
              if (initial.isNotEmpty) onDataReceived(initial);
            } catch (e) {
              _logger.e('Initial read error: $e');
            }

            // notifications stream
            chr.lastValueStream.listen((data) {
              onDataReceived(data);

              // ─── AI Prediction ───────────────────────────────────────
              final raw = utf8.decode(data);
              final parts = raw.split(',');
              final parsed = <String, double>{};
              for (var p in parts) {
                final kv = p.split(':');
                if (kv.length == 2) {
                  parsed[kv[0]] = double.tryParse(kv[1]) ?? 0.0;
                }
              }
              final values = [
                parsed['Flex1'] ?? 0,
                parsed['Flex2'] ?? 0,
                parsed['Flex3'] ?? 0,
                parsed['Flex4'] ?? 0,
                parsed['Flex5'] ?? 0,
                parsed['AccX'] ?? 0,
                parsed['AccY'] ?? 0,
                parsed['AccZ'] ?? 0,
                parsed['GyroX'] ?? 0,
                parsed['GyroY'] ?? 0,
                parsed['GyroZ'] ?? 0,
                parsed['Temp'] ?? 0,
              ];
              final gesture = _aiService.predict(values);
              if (gesture != null) onGestureReceived?.call(gesture);
              // ─────────────────────────────────────────────────────────
            }, onError: (e) {
              _logger.e('Notification error: $e');
            });
          }
        }
      }
    }
  }

  Future<void> disconnect() async {
    if (connectedDevice != null) {
      _logger.i('🔌 Disconnecting from ${connectedDevice!.remoteId.str}');
      await connectedDevice!.disconnect();
      _isConnected = false;
      _logger.i('⚡ Disconnected');
    }
  }
}
