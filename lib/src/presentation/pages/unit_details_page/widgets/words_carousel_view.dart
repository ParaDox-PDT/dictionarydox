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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    
    // Web uchun carousel height ni cheklash
    final carouselHeight = isWeb
        ? (screenHeight * 0.65).clamp(400.0, 600.0) // Web: max 600px
        : screenHeight * 0.75; // Mobile: 75% of screen
    
    return CarouselSlider.builder(
      itemCount: words.length,
      options: CarouselOptions(
        height: carouselHeight,
        viewportFraction: isWeb ? 0.7 : 0.85, // Web uchun kichikroq viewport
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
