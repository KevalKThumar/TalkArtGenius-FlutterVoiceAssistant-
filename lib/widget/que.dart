import 'package:flutter/material.dart';

Visibility question(
    String lastWords, String? genaretedConntent, String? genaratedImageUrl) {
  return Visibility(
    visible: genaretedConntent == null && genaratedImageUrl == null,
    child: Container(
      padding: const EdgeInsets.all(10),
      child: Text(
        lastWords,
        style: const TextStyle(
          fontFamily: "Cera Pro",
          fontSize: 20,
        ),
      ),
    ),
  );
}
