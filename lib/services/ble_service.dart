// lib/services/ble_service.dart

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class BleService {
  static const String targetDeviceId = '08:D1:F9:CC:16:3E';
  static final Guid serviceUuid =
      Guid.parse('4fafc201-1fb5-459e-8fcc-c5c9c331914b')!;
  static final Guid charUuid =
      Guid.parse('beb5483e-36e1-4688-b7f5-ea07361b26a8')!;

  BluetoothDevice? connectedDevice;
  bool _isConnected = false;

  void startScan(Function(BluetoothDevice) onDeviceFound) {
    _logger.i('📡 Starting scan for target MAC: $targetDeviceId');
    FlutterBluePlus.startScan(
      withRemoteIds: [targetDeviceId],
      timeout: const Duration(seconds: 5),
      androidScanMode: AndroidScanMode.balanced,
    );

    FlutterBluePlus.scanResults.listen((results) {
      for (var r in results) {
        final remoteId = r.device.remoteId.str;
        _logger.i('🔍 Found device: $remoteId (RSSI: ${r.rssi})');
        if (!_isConnected && remoteId == targetDeviceId) {
          _isConnected = true;
          FlutterBluePlus.stopScan();
          _logger.i('✅ Target device found: $remoteId');
          onDeviceFound(r.device);
          break;
        }
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    final id = device.remoteId.str;
    _logger.i('🔗 Connecting to: $id');
    await device.connect(autoConnect: false);
    connectedDevice = device;
    _logger.i('✅ Connected to: $id');
  }

  Future<void> listenToData(Function(List<int>) onDataReceived) async {
    if (connectedDevice == null) return;

    _logger.i('🔍 Discovering services...');
    final services = await connectedDevice!.discoverServices();

    for (var svc in services) {
      _logger.i('🔧 Discovered service: ${svc.uuid}');
      if (svc.uuid == serviceUuid) {
        _logger.i('✅ Target service found: $serviceUuid');
        for (var chr in svc.characteristics) {
          _logger.i('🔧 Characteristic: ${chr.uuid}');
          if (chr.uuid == charUuid) {
            _logger.i('🔔 Subscribing to characteristic: $charUuid');
            await chr.setNotifyValue(true);

            try {
              final initial = await chr.read();
              if (initial.isNotEmpty) {
                _logger.i('📨 Initial data: $initial');
                onDataReceived(initial);
              }
            } catch (e) {
              _logger.e('Error during initial read: $e');
            }

            chr.lastValueStream.listen(
              (data) {
                onDataReceived(data);
              },
              onError: (e) {
                _logger.e('Error while listening to notifications: $e');
              },
            );
          }
        }
      }
    }
  }

  Future<void> disconnect() async {
    if (connectedDevice != null) {
      final id = connectedDevice!.remoteId.str;
      _logger.i('🔌 Disconnecting from: $id');
      await connectedDevice!.disconnect();
      _isConnected = false;
      _logger.i('⚡ Disconnected');
    }
  }
}
