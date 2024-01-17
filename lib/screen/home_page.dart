// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_assistant/Provider/assistant_provider.dart';
import 'package:voice_assistant/widget/feature_box.dart';
import 'package:voice_assistant/widget/que.dart';
import '../common/colors.dart';
import '../widget/assistant_pic.dart';
import '../widget/chat_bubble.dart';
import '../widget/generated_image.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
  int delay = 200;

    final AssistanceProvider assistantprovider = Provider.of<AssistanceProvider>(context);

    assistantprovider.initSpeechToText();

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
                  assistantprovider.lastWords,
                  assistantprovider.genaretedConntent,
                  assistantprovider.genaratedImageUrl,
                ),

                // chat bubble
                chatBubble(
                  assistantprovider.genaretedConntent,
                  assistantprovider.genaratedImageUrl,
                  assistantprovider.isProcessing,
                ),

                // generated image

                if (assistantprovider.genaratedImageUrl != null)
                  generatedImage(context, assistantprovider.genaratedImageUrl!),

                // message
                SlideInLeft(
                  child: Visibility(
                    visible: assistantprovider.genaretedConntent == null &&
                        assistantprovider.genaratedImageUrl == null,
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
                  visible: assistantprovider.genaretedConntent == null &&
                      assistantprovider.genaratedImageUrl == null,
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
        floatingActionButton: assistantprovider. isSpeechStart
            ? ZoomIn(
                animate: true,
                child: FloatingActionButton(
                  onPressed: () {
                    
                    assistantprovider.flutterTts.stop();
                    assistantprovider.setIsSppeechStart(false);
                  },
                  backgroundColor: Pallete.secondSuggestionBoxColor,
                  child: const Icon(Icons.stop),
                ))
            : ZoomIn(
                animate: true,
                delay: Duration(milliseconds: delay * 4),
                child: FloatingActionButton(
                  onPressed: () async {
                    if (await assistantprovider.speechToText.hasPermission &&
                        assistantprovider.speechToText.isNotListening) {
                      await assistantprovider.startListening();
                    } else if (assistantprovider.speechToText.isListening) {
                      await assistantprovider.stopListening();
                    } else {
                      assistantprovider.initSpeechToText();
                    }
                  },
                  backgroundColor: Pallete.firstSuggestionBoxColor,
                  child: Icon(
                    assistantprovider.speechToText.isListening ? Icons.stop : Icons.mic,
                  ),
                ),
              ),
      ),
    );
  }
}
