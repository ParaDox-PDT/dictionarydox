import 'package:cached_network_image/cached_network_image.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_event.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_state.dart';
import 'package:dictionarydox/src/presentation/widgets/image_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageQuizContent extends StatelessWidget {
  final QuizInProgress state;

  const ImageQuizContent({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          state.currentWord.english,
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.imageOptions?.length ?? 0,
            itemBuilder: (context, index) {
              final imageUrl = state.imageOptions![index];
              final isSelected = state.selectedImageIndex == index;
              final isCorrectAnswer = state.correctImageIndex == index;

              Color borderColor = Colors.transparent;
              if (state.isCorrect != null) {
                if (isCorrectAnswer) {
                  borderColor = Colors.green;
                } else if (isSelected && !isCorrectAnswer) {
                  borderColor = Colors.red;
                }
              } else if (isSelected) {
                borderColor = Theme.of(context).primaryColor;
              }

              return GestureDetector(
                onTap: state.isCorrect == null
                    ? () => context
                        .read<QuizBloc>()
                        .add(SelectImageOptionEvent(index))
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: borderColor,
                      width: 4,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ImageShimmer(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
