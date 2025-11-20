import 'package:dictionarydox/src/core/utils/platform_utils.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/widgets/word_list_card.dart';
import 'package:flutter/material.dart';

class WordsListView extends StatelessWidget {
  final List<dynamic> words;
  final Function(dynamic word) onPlayAudio;
  final Function(dynamic word) onDelete;
  final Function(String imageUrl) onImageTap;

  const WordsListView({
    super.key,
    required this.words,
    required this.onPlayAudio,
    required this.onDelete,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = PlatformUtils.isWeb;
    
    if (isWeb) {
      // Web: Display in 2 columns
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return WordListCard(
            word: word,
            onPlayAudio: () => onPlayAudio(word),
            onDelete: () => onDelete(word),
            onImageTap: () =>
                word.imageUrl != null ? onImageTap(word.imageUrl!) : null,
          );
        },
      );
    } else {
      // Mobile: Display in single column
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: WordListCard(
              word: word,
              onPlayAudio: () => onPlayAudio(word),
              onDelete: () => onDelete(word),
              onImageTap: () =>
                  word.imageUrl != null ? onImageTap(word.imageUrl!) : null,
            ),
          );
        },
      );
    }
  }
}
