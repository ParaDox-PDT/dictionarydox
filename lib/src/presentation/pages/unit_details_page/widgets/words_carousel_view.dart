import 'package:carousel_slider/carousel_slider.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/widgets/word_carousel_card.dart';
import 'package:flutter/material.dart';

class WordsCarouselView extends StatelessWidget {
  final List<dynamic> words;
  final Function(dynamic word) onPlayAudio;
  final Function(dynamic word) onDelete;
  final Function(String imageUrl) onImageTap;

  const WordsCarouselView({
    super.key,
    required this.words,
    required this.onPlayAudio,
    required this.onDelete,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: words.length,
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.75,
        viewportFraction: 0.85,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        autoPlay: false,
      ),
      itemBuilder: (context, index, realIndex) {
        final word = words[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: WordCarouselCard(
            word: word,
            onPlayAudio: () => onPlayAudio(word),
            onDelete: () => onDelete(word),
            onImageTap: () => onImageTap(word.imageUrl!),
          ),
        );
      },
    );
  }
}
