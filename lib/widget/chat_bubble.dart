import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../common/colors.dart';

FadeInRight chatBubble(
  String? genaretedConntent,
  String? genaratedImageUrl,
  bool isProcessing,
) {
  return FadeInRight(
    child: Visibility(
      visible: genaratedImageUrl == null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(
          top: 30,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Pallete.borderColor,
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: isProcessing
            ? const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
              Pallete.blackColor,
            )))
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                child: Text(
                  genaretedConntent ?? "Hi, I am your personal assistant. How may I help you?",
                  style: TextStyle(
                    color: Pallete.mainFontColor,
                    fontSize: genaretedConntent == null ? 20 : 18,
                    fontFamily: "Cera Pro",
                  ),
                ),
              ),
      ),
    ),
  );
}
