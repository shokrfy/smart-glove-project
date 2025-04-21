import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
// للحصول على لغة الجهاز

class SpeechToTextService {
  final stt.SpeechToText speech = stt.SpeechToText();

  // دالة لطلب إذن الميكروفون
  Future<void> requestMicrophonePermission() async {
    if (await Permission.microphone.isDenied) {
      await Permission.microphone.request();
    }
  }

  // دالة للحصول على لغة الجهاز تلقائيًا
  String getDeviceLanguage() {
    String locale = PlatformDispatcher.instance.locale.languageCode;
    if (locale == "ar") {
      return "ar_SA"; // اللغة العربية
    } else {
      return "en_US"; // اللغة الإنجليزية كافتراضية
    }
  }

  Future<void> startListening(Function(String) onResult) async {
    await requestMicrophonePermission(); // طلب الإذن قبل بدء الاستماع

    String locale = getDeviceLanguage(); // الحصول على لغة الجهاز تلقائيًا

    try {
      bool available = await speech.initialize(
        onStatus: (status) {
          debugPrint("🔄 Speech recognition status: $status");
        },
        onError: (errorNotification) {
          debugPrint("❌ Speech-to-Text Error: $errorNotification");

          // معالجة خطأ عدم تطابق الصوت (error_no_match)
          if (errorNotification.errorMsg == "error_no_match") {
            debugPrint("⚠️ No speech detected. Please try again.");
          }
        },
      );

      debugPrint(
          "🎤 Speech recognition initialized: $available | Language: $locale");

      if (available) {
        speech.listen(
          onResult: (result) {
            debugPrint("📝 Recognized words: ${result.recognizedWords}");

            // التأكد من أن النص النهائي جاهز قبل إرساله
            if (result.finalResult && result.recognizedWords.isNotEmpty) {
              onResult(result.recognizedWords);
            }
          },
          localeId: locale, // استخدام لغة الجهاز تلقائيًا
          onSoundLevelChange: (level) {
            debugPrint("🔊 Sound level: $level");
          },
          listenFor:
              Duration(seconds: 10), // يوقف الاستماع تلقائيًا بعد 10 ثوانٍ
          pauseFor: Duration(
              seconds: 3), // يوقف التسجيل إذا توقف الشخص عن الكلام لثوانٍ
        );
      } else {
        debugPrint("⚠️ Speech-to-Text initialization failed!");
      }
    } catch (e) {
      debugPrint("❌ Speech-to-Text Exception: $e");
    }
  }

  // دالة لإيقاف الاستماع يدويًا
  Future<void> stopListening() async {
    await speech.stop();
    debugPrint("🛑 Speech recognition stopped.");
  }
}
