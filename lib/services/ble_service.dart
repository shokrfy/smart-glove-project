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

  // ─── AI الربط ───────────────────────────────────────────────
  final AIService _aiService = AIService();
  Function(String)? onGestureReceived;
  void setOnGestureReceivedCallback(Function(String) cb) =>
      onGestureReceived = cb;

  bool _modelLoadingInitiated = false;

  // مجمّع الإطار (12 قيمة)
  List<double?> _frame = List.filled(12, null);
  static const Map<String, int> _keyIndex = {
    'Flex1': 0,
    'Flex2': 1,
    'Flex3': 2,
    'Flex4': 3,
    'Flex5': 4,
    'AccX': 5,
    'AccY': 6,
    'AccZ': 7,
    'GyroX': 8,
    'GyroY': 9,
    'GyroZ': 10,
    'Temp': 11,
  };
  // ────────────────────────────────────────────────────────────

  /// مسح ضوئى عن ESP32_Glove
  void startScan(Function(BluetoothDevice) onDeviceFound) {
    if (connectedDevice != null) return; // متصل بالفعل
    _logger.i('📡 Scanning for ESP32_Glove …');
    FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
      androidScanMode: AndroidScanMode.balanced,
    );

    FlutterBluePlus.scanResults.listen((results) {
      for (var r in results) {
        if (r.device.platformName == 'ESP32_Glove') {
          FlutterBluePlus.stopScan();
          _logger.i('✅ Found ESP32_Glove');
          onDeviceFound(r.device);
          break;
        }
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect(autoConnect: false);
    connectedDevice = device;
    _logger.i('🔗 Connected to ${device.remoteId.str}');

    if (!_modelLoadingInitiated) {
      await _aiService.loadModel();
      _modelLoadingInitiated = true;
    }
  }

  Future<void> listenToData(void Function(List<int>) onRawData) async {
    if (connectedDevice == null || !_aiService.isModelLoaded) return;

    final services = await connectedDevice!.discoverServices();
    for (var svc in services) {
      if (svc.uuid == serviceUuid) {
        for (var chr in svc.characteristics) {
          if (chr.uuid == charUuid) {
            await chr.setNotifyValue(true);
            chr.lastValueStream.listen((data) {
              onRawData(data); // لوج حىّ
              _handlePacket(utf8.decode(data));
            });
          }
        }
      }
    }
  }

  // ─── تجميع الحقول المفردة حتى تكتمل الـ 12 قيمة ──────────
  void _handlePacket(String raw) {
    final kv = raw.split(':');
    if (kv.length != 2) return;

    final idx = _keyIndex[kv[0]];
    if (idx == null) return;

    _frame[idx] = double.tryParse(kv[1]);
    _logger.d('📥 ${kv[0]} → ${_frame[idx]}');

    if (_frame.every((v) => v != null)) {
      final gesture = _aiService.predict(_frame.cast<double>());
      if (gesture != null) onGestureReceived?.call(gesture);
      _frame = List.filled(12, null); // إطار جديد
    }
  }
}
