import 'dart:async';
import 'scan_result.dart';
import 'bluetooth_device.dart';

class FlutterBluePlus {
  FlutterBluePlus._();
  static final FlutterBluePlus instance = FlutterBluePlus._();

  final _scanResultsController = StreamController<List<ScanResult>>.broadcast();

  void startScan({required Duration timeout}) {
    _scanResultsController.add([
      ScanResult(device: BluetoothDevice(name: 'ESP_GLOVE'))
    ]);
    Future.delayed(timeout, stopScan);
  }

  void stopScan() {}

  Stream<List<ScanResult>> get scanResults => _scanResultsController.stream;
}