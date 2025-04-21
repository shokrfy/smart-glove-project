import 'dart:async';
import 'bluetooth_properties.dart';

class BluetoothCharacteristic {
  final CharacteristicProperties properties = CharacteristicProperties();
  final StreamController<List<int>> _valueController = StreamController.broadcast();

  Stream<List<int>> get value => _valueController.stream;

  Future<void> setNotifyValue(bool enabled) async {
    if (enabled) {
      Timer.periodic(Duration(seconds: 2), (_) {
        _valueController.add([1, 2, 3, 4]);
      });
    }
  }
}