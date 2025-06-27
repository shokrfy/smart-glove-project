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

  /// عدد القيم المطلوبة للموديل (Flex1-Flex5 + AccX-AccZ + GyroX-GyroZ) = 11
  static const int _inputSize = 11;

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

  /// [input] يجب أن يحتوى **11** قيمة بالترتيب:
  /// Flex1, Flex2, Flex3, Flex4, Flex5, AccX, AccY, AccZ, GyroX, GyroY, GyroZ
  String? predict(List<double> input) {
    if (!_isLoaded) return null;
    if (input.length != _inputSize) {
      _log.w('⚠️ Expected $_inputSize inputs, got ${input.length}');
      return null;
    }

    // الشكل المطلوب للموديل: [1, 11]
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

/// Apply StandardScaler (mean/std) exactly like Python training
List<double> applyStandardScaler(List<double> input) {
  const means = [
    3619.263499,
    3525.562635,
    3781.760259,
    3558.464363,
    4095.000000,
    12631.641469,
    4355.637149,
    3.330454,
    -331.132829,
    27.801296,
    -439.443844,
  ];
  const stds = [
    137.527597,
    295.856223,
    443.162831,
    248.358456,
    1.000000,
    4404.401685,
    7630.018912,
    6435.828179,
    8879.383146,
    6977.595363,
    7666.527167,
  ];

  return List<double>.generate(
    input.length,
    (i) => (input[i] - means[i]) / stds[i],
  );
}
