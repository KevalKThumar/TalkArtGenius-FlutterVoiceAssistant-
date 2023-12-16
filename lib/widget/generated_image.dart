import 'package:flutter/material.dart';
import 'package:voice_assistant/services/image_save.dart';

import '../common/colors.dart';

Column generatedImage(
  BuildContext context,
  String? genaratedImageUrl,
) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        margin: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image(
            image: NetworkImage(genaratedImageUrl!),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      Pallete.blackColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      // image download button

      SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width - 50,
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Downloading...",
                ),
              ),
            );
            downloadImage(genaratedImageUrl, context);
          },
          child: const Text(
            "Download",
            style: TextStyle(
              fontFamily: "Cera Pro",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  );
}
