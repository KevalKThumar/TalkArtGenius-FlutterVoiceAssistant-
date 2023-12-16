import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:voice_assistant/common/colors.dart';

ZoomIn assistantPicture() {
  return ZoomIn(
    child: Stack(
      children: [
        Center(
          child: Container(
            height: 120,
            width: 120,
            margin: const EdgeInsets.only(top: 4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Pallete.assistantCircleColor,
            ),
          ),
        ),
        Container(
          height: 123,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage("assets/images/virtualAssistant.png"),
            ),
          ),
        )
      ],
    ),
  );
}
