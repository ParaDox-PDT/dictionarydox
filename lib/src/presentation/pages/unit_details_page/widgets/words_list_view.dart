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
