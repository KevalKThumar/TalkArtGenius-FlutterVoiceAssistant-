import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../services/openai_services.dart';

class AssistanceProvider with ChangeNotifier {
  final SpeechToText speechToText = SpeechToText();
  final OpenAIService openAIService = OpenAIService();
  final FlutterTts flutterTts = FlutterTts();
  bool _speechEnabled = false;
  String _lastWords = '';
  String? _genaretedConntent;
  String? _genaratedImageUrl;
  bool _isProcessing = false;
  bool _isSpeechStart = false;

  bool get speechEnabled => _speechEnabled;
  String get lastWords => _lastWords;
  String? get genaretedConntent => _genaretedConntent;
  String? get genaratedImageUrl => _genaratedImageUrl;
  bool get isProcessing => _isProcessing;
  bool get isSpeechStart => _isSpeechStart;

  

  void setSeechEnabled(val) {
    _speechEnabled = val;
    notifyListeners();
  }

  void setGenaretedConntent(val) {
    _genaretedConntent = val;
    notifyListeners();
  }

  void setLasWord(val) {
    _lastWords = val;
    notifyListeners();
  }

  void setGenaratedImageUrl(val) {
    _genaratedImageUrl = val;
    notifyListeners();
  }

  void setIsProcessing(val) {
    _isProcessing = val;
    notifyListeners();
  }

  void setIsSppeechStart(val) {
    _isSpeechStart = val;
    notifyListeners();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    notifyListeners();
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    notifyListeners();
  }

  Future<void> startListening() async {
    setGenaratedImageUrl(null);
    setGenaretedConntent(null);
    await speechToText.listen(onResult: onSpeechResult);
    notifyListeners();
  }

  void onSpeechResult(SpeechRecognitionResult result) async {
    setLasWord(result.recognizedWords);
    if (result.finalResult) {
      setIsProcessing(true);
    }

    if (result.finalResult) {
      final speech = await openAIService.isArtPromptAPI(_lastWords);
      if (speech.contains("https")) {
        setGenaratedImageUrl(speech);
        setGenaretedConntent(null);
        setIsProcessing(false);
      } else {
        setGenaretedConntent(speech);
        setGenaratedImageUrl(null);
        setIsProcessing(false);

        if (_genaretedConntent != null) {
          setIsSppeechStart(true);
          textToSpeech();
        }
      }
    }
  }

  textToSpeech() async {
    flutterTts.setSilence(500);
    flutterTts.setLanguage("en-IN");
    flutterTts.setPitch(1);
    flutterTts.setVolume(1);
    flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(_genaretedConntent!);
    flutterTts.setCompletionHandler(() {
      setIsSppeechStart(false);
    });
  }
}
