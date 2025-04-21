import 'bluetooth_service.dart';
import 'bluetooth_characteristic.dart';

class BluetoothDevice {
  final String name;
  BluetoothDevice({required this.name});

  Future<void> connect() async {}

  Future<void> disconnect() async {}

  Future<List<BluetoothService>> discoverServices() async {
    return [BluetoothService([BluetoothCharacteristic()])];
  }
}