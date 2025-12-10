import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final FlutterTts _tts = FlutterTts();

  VoiceService() {
    _init();
  }

  void _init() async {
    // Settingan agar mirip "The System"
    await _tts.setLanguage("id-ID"); // Bahasa Indonesia
    await _tts.setPitch(0.8);        // Agak berat (Default 1.0)
    await _tts.setSpeechRate(0.4);   // Agak lambat & jelas (Default 0.5)
    await _tts.setVolume(1.0);
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await _tts.speak(text);
    }
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}