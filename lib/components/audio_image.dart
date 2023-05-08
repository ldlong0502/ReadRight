

import 'package:ebook/components/cache_image_ebook.dart';
import 'package:ebook/models/audio_book.dart';
import 'package:flutter/material.dart';

import '../theme/theme_config.dart';

class AudioImage extends StatelessWidget {
  const AudioImage({super.key, required this.audioBook, required this.size});
  final AudioBook audioBook;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CacheImageEbook(url: audioBook.image,),
        Positioned.fill(
            child: Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.play_circle_filled_sharp,
            color: ThemeConfig.lightPrimary,
            size: size,
          ),
        ))
      ],
    );
  }
}