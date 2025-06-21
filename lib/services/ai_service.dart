import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final Logger _logger = Logger();
  late Interpreter _interpreter;
  final List<String> _labels = [];
  bool _isLoaded = false;

  Future<void> loadModel() async {
    try {
      _logger.i('📦 Loading TFLite model...');
      final options = InterpreterOptions()..threads = 2;
      _interpreter =
          await Interpreter.fromAsset('gesture_model.tflite', options: options);
      final labelRaw = await rootBundle.loadString('assets/gesture_labels.txt');
      _labels.addAll(
          labelRaw.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty));
      _isLoaded = true;
      _logger.i('✅ Model loaded with ${_labels.length} labels');
    } catch (e) {
      _logger.e('❌ Failed to load model: $e');
    }
  }

  String? predict(List<double> input) {
    if (!_isLoaded) {
      _logger.w('⚠️ Model not loaded');
      return null;
    }

    if (input.length != 12) {
      _logger.w('⚠️ Input must contain 12 values, but got ${input.length}');
      return null;
    }

    final inputTensor = [input];
    final outputTensor = List<List<double>>.generate(
      1,
      (_) => List<double>.filled(_labels.length, 0),
    );

    try {
      _interpreter.run(inputTensor, outputTensor);
    } catch (e) {
      _logger.e('❌ Inference failed: $e');
      return null;
    }

    final row = outputTensor[0];
    final maxVal = row.reduce((a, b) => a > b ? a : b);
    final idx = row.indexOf(maxVal);

    _logger.i('🤖 Prediction: ${_labels[idx]} (Confidence: $maxVal)');
    return _labels[idx];
  }

  bool get isModelLoaded => _isLoaded;
}
