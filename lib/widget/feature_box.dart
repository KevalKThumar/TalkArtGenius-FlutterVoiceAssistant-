// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:voice_assistant/common/colors.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String title;
  final String subTitle;
  const FeatureBox({
    Key? key,
    required this.color,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child:  ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Pallete.blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: "Cera Pro",
          ),
        ),
        subtitle: Text(
          subTitle,
          style: const TextStyle(
            color: Pallete.blackColor,
            fontWeight: FontWeight.w500,
            fontSize: 20,
            fontFamily: "Cera Pro",
          ),
        ),
      ),
    );
  }
}
