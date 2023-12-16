// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;

downloadImage(String imageUrl, BuildContext context) async {
  final Random random = Random();
  final String randomName = random.nextInt(100000).toString();
  try {
    final url = Uri.parse(imageUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(bytes),
        quality: 60,
        name: randomName,
      );
      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Image Downloaded",
          ),
        ));
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Failed to download image",
      ),
    ));
  }
}
