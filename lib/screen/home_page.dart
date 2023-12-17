// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/services/openai_services.dart';
import 'package:voice_assistant/widget/feature_box.dart';
import 'package:voice_assistant/widget/que.dart';
import '../common/colors.dart';
import '../widget/assistant_pic.dart';
import '../widget/chat_bubble.dart';
import '../widget/generated_image.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // defination
  final SpeechToText speechToText = SpeechToText();
  final OpenAIService openAIService = OpenAIService();
  final FlutterTts flutterTts = FlutterTts();
  bool speechEnabled = false;
  String lastWords = '';
  String? genaretedConntent;
  String? genaratedImageUrl;
  bool isProcessing = false;
  int start = 200;
  int delay = 200;
  bool isSpeechStart = false;

  @override
  void initState() {
    initSpeechToText();
    super.initState();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  Future<void> startListening() async {
    setState(() {
      genaratedImageUrl = null;
      genaretedConntent = null;
    });

    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      lastWords = result.recognizedWords;
      if (result.finalResult) {
        isProcessing = true;
      }
    });

    if (result.finalResult) {
      final speech = await openAIService.isArtPromptAPI(lastWords);
      if (speech.contains("https")) {
        genaratedImageUrl = speech;
        genaretedConntent = null;
        setState(() {
          isProcessing = false;
        });
      } else {
        genaretedConntent = speech;
        genaratedImageUrl = null;
        setState(() {
          isProcessing = false;
        });

        if (genaretedConntent != null) {
          setState(() {
            isSpeechStart = true;
          textToSpeech();
          });
        }
      }
    }
  }

  // text to speech
  textToSpeech() async {
    
    flutterTts.setSilence(500);
    flutterTts.setLanguage("en-IN");
    flutterTts.setPitch(1);
    flutterTts.setVolume(1);
    flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(genaretedConntent!);
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeechStart = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: BounceInDown(
              child: const Text("Voice Assistant",
                  style: TextStyle(
                    fontFamily: "Cera Pro",
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            centerTitle: true,
            leading: const Icon(Icons.menu),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  // virtual assistant picture
                  assistantPicture(),

                  //  question
                  question(
                    lastWords,
                    genaretedConntent,
                    genaratedImageUrl,
                  ),

                  // chat bubble
                  chatBubble(
                    genaretedConntent,
                    genaratedImageUrl,
                    isProcessing,
                  ),

                  // generated image

                  if (genaratedImageUrl != null)
                    generatedImage(context, genaratedImageUrl!),

                  // message
                  SlideInLeft(
                    child: Visibility(
                      visible: genaretedConntent == null &&
                          genaratedImageUrl == null,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(
                          top: 10,
                          left: 20,
                        ),
                        child: const Text(
                          "Here are a few features",
                          style: TextStyle(
                            color: Pallete.mainFontColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Cera Pro",
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Feature List

                  Visibility(
                    visible:
                        genaretedConntent == null && genaratedImageUrl == null,
                    child: Column(
                      children: [
                        SlideInLeft(
                          delay: Duration(milliseconds: delay),
                          child: const FeatureBox(
                            color: Pallete.firstSuggestionBoxColor,
                            title: "ChatGPT",
                            subTitle:
                                "A smarter way to stay organized and informed with chtatGPT",
                          ),
                        ),
                        SlideInLeft(
                          delay: Duration(milliseconds: delay * 2),
                          child: const FeatureBox(
                            color: Pallete.secondSuggestionBoxColor,
                            title: "Dall-E",
                            subTitle:
                                "Get inspired and stay creative with your personal assistant powered by Dall-E",
                          ),
                        ),
                        SlideInLeft(
                          delay: Duration(milliseconds: delay * 3),
                          child: const FeatureBox(
                            color: Pallete.thirdSuggestionBoxColor,
                            title: "Smart Voice",
                            subTitle:
                                "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT",
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: isSpeechStart
              ? ZoomIn(
                  animate: true,
                  child: FloatingActionButton(
                    onPressed: () {
                      flutterTts.stop();
                      setState(() {
                        isSpeechStart = false;
                      });
                    },
                    backgroundColor: Pallete.secondSuggestionBoxColor,
                    child: const Icon(Icons.stop),
                  ))
              : ZoomIn(
                  animate: true,
                  delay: Duration(milliseconds: delay * 4),
                  child: FloatingActionButton(
                      onPressed: () async {
                        if (await speechToText.hasPermission &&
                            speechToText.isNotListening) {
                          await startListening();
                        } else if (speechToText.isListening) {
                          await stopListening();
                        } else {
                          initSpeechToText();
                        }
                      },
                      backgroundColor: Pallete.firstSuggestionBoxColor,
                      child: Icon(
                        speechToText.isListening ? Icons.stop : Icons.mic,
                      )),
                )),
    );
  }
}
