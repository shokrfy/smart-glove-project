
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class BleService {
  BluetoothDevice? connectedDevice;
  bool _isConnected = false;

  void startScan(Function(BluetoothDevice) onDeviceFound) {
    FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.instance.scanResults.listen((results) {
      bool deviceFound = false;

      for (ScanResult r in results) {
        _logger.i('🔎 Found: \${r.device.name}');
        if (r.device.name == "ESP_GLOVE" && !_isConnected) {
          deviceFound = true;
          _isConnected = true;
          FlutterBluePlus.instance.stopScan();
          onDeviceFound(r.device);
          break;
        }
      }

      if (!deviceFound && !_isConnected) {
        _logger.i("🔁 Retrying scan in 2 seconds...");
        Future.delayed(
          const Duration(seconds: 2),
          () => startScan(onDeviceFound),
        );
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    connectedDevice = device;
    _logger.i("✅ Connected to \${device.name}");
  }

  Future<void> listenToData(Function(List<int>) onDataReceived) async {
    if (connectedDevice == null) return;

    List<BluetoothService> services = await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          await characteristic.setNotifyValue(true);
          characteristic.value.listen(onDataReceived);
        }
      }
    }
  }

  Future<void> disconnect() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      _isConnected = false;
      _logger.i("🔌 Disconnected");
    }
  }
}
