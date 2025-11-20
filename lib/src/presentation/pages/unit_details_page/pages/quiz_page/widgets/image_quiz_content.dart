import 'package:cached_network_image/cached_network_image.dart';
import 'package:dictionarydox/src/core/utils/platform_utils.dart';
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

  Widget _buildImageItem(
    BuildContext context,
    String imageUrl,
    int index,
    bool isSelected,
    bool isCorrectAnswer,
  ) {
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
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isWeb = PlatformUtils.isWeb;
    final imageCount = state.imageOptions?.length ?? 0;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          state.currentWord.english,
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        if (isWeb && (imageCount == 4 || imageCount == 2))
          // Web uchun 2 yoki 4 ta rasm - responsive grid, scroll qilmaslik
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableHeight = constraints.maxHeight;
                final availableWidth = constraints.maxWidth;
                final spacing = 16.0;
                final padding = 16.0;
                
                // Responsive o'lcham hisoblash
                double imageSize;
                if (imageCount == 2) {
                  // 2 ta rasm - 1x2 yoki 2x1 layout
                  imageSize = ((availableWidth - padding * 2 - spacing) / 2)
                      .clamp(150.0, (availableHeight - padding * 2) * 0.8);
                } else {
                  // 4 ta rasm - 2x2 grid
                  imageSize = ((availableWidth - padding * 2 - spacing) / 2)
                      .clamp(100.0, (availableHeight - padding * 2 - spacing) / 2);
                }
                
                return Padding(
                  padding: EdgeInsets.all(padding),
                  child: imageCount == 2
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: imageSize,
                              height: imageSize,
                              child: _buildImageItem(
                                context,
                                state.imageOptions![0],
                                0,
                                state.selectedImageIndex == 0,
                                state.correctImageIndex == 0,
                              ),
                            ),
                            SizedBox(width: spacing),
                            SizedBox(
                              width: imageSize,
                              height: imageSize,
                              child: _buildImageItem(
                                context,
                                state.imageOptions![1],
                                1,
                                state.selectedImageIndex == 1,
                                state.correctImageIndex == 1,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: imageSize,
                                  height: imageSize,
                                  child: _buildImageItem(
                                    context,
                                    state.imageOptions![0],
                                    0,
                                    state.selectedImageIndex == 0,
                                    state.correctImageIndex == 0,
                                  ),
                                ),
                                SizedBox(width: spacing),
                                SizedBox(
                                  width: imageSize,
                                  height: imageSize,
                                  child: _buildImageItem(
                                    context,
                                    state.imageOptions![1],
                                    1,
                                    state.selectedImageIndex == 1,
                                    state.correctImageIndex == 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: spacing),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: imageSize,
                                  height: imageSize,
                                  child: _buildImageItem(
                                    context,
                                    state.imageOptions![2],
                                    2,
                                    state.selectedImageIndex == 2,
                                    state.correctImageIndex == 2,
                                  ),
                                ),
                                SizedBox(width: spacing),
                                SizedBox(
                                  width: imageSize,
                                  height: imageSize,
                                  child: _buildImageItem(
                                    context,
                                    state.imageOptions![3],
                                    3,
                                    state.selectedImageIndex == 3,
                                    state.correctImageIndex == 3,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                );
              },
            ),
          )
        else
          // Mobile yoki boshqa holatlar uchun GridView
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: isWeb
                    ? (screenHeight * 0.5).clamp(300.0, 500.0)
                    : screenHeight * 0.6,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = MediaQuery.of(context).size.width;
                  final crossAxisCount = width > 600 ? 2 : 2;
                  final spacing = width > 600 ? 16.0 : 12.0;

                  return GridView.builder(
                    padding: EdgeInsets.all(spacing),
                    shrinkWrap: true,
                    physics: isWeb && (imageCount == 4 || imageCount == 2)
                        ? const NeverScrollableScrollPhysics()
                        : const AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: imageCount,
                    itemBuilder: (context, index) {
                      final imageUrl = state.imageOptions![index];
                      final isSelected = state.selectedImageIndex == index;
                      final isCorrectAnswer = state.correctImageIndex == index;

                      return _buildImageItem(
                        context,
                        imageUrl,
                        index,
                        isSelected,
                        isCorrectAnswer,
                      );
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
