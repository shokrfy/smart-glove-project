import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final _log = Logger();
  late Interpreter _interpreter;
  late int _numOutputs;
  final List<String> _labels = [];
  bool _isLoaded = false;

  Future<void> loadModel() async {
    try {
      _log.i('📦 Loading TFLite model…');

      _interpreter = await Interpreter.fromAsset(
        'assets/gesture_model.tflite',
        options: InterpreterOptions()..threads = 2,
      );
      _numOutputs = _interpreter.getOutputTensor(0).shape[1];

      final raw = await rootBundle.loadString('assets/gesture_labels.txt');
      _labels
        ..clear()
        ..addAll(
          raw.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty),
        );

      if (_labels.length != _numOutputs) {
        _log.w(
          '⚠️ labels (${_labels.length}) ≠ model outputs ($_numOutputs). '
          'Using indexes instead of names where necessary.',
        );
      }

      _isLoaded = true;
      _log.i('✅ Model ready ($_numOutputs classes)');
    } catch (e) {
      _log.e('❌ loadModel failed: $e');
    }
  }

  /// [input] يجب أن يحتوى 12 قيمة بالترتيب (Flex1..Temp)
  String? predict(List<double> input) {
    if (!_isLoaded) return null;
    if (input.length != 12) {
      _log.w('⚠️ Expected 12 inputs, got ${input.length}');
      return null;
    }

    final output = List.generate(1, (_) => List.filled(_numOutputs, 0.0));
    _interpreter.run([input], output);

    final probs = output[0];
    final max = probs.reduce((a, b) => a > b ? a : b);
    final idx = probs.indexOf(max);

    final label = idx < _labels.length ? _labels[idx] : 'Gesture_$idx';

    _log.i('🤖 $label (${max.toStringAsFixed(2)})');
    return label;
  }

  bool get isModelLoaded => _isLoaded;
}
