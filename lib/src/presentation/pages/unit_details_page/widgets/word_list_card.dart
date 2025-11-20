import 'package:cached_network_image/cached_network_image.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_card.dart';
import 'package:dictionarydox/src/presentation/widgets/image_shimmer.dart';
import 'package:flutter/material.dart';

class WordListCard extends StatelessWidget {
  final dynamic word;
  final VoidCallback onPlayAudio;
  final VoidCallback onDelete;
  final VoidCallback onImageTap;

  const WordListCard({
    super.key,
    required this.word,
    required this.onPlayAudio,
    required this.onDelete,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    
    return DdCard(
      padding: isWeb ? const EdgeInsets.all(12.0) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (word.imageUrl != null)
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Responsive image size based on screen width
                    final screenWidth = MediaQuery.of(context).size.width;
                    final imageSize = screenWidth > 600
                        ? 80.0 // Desktop/Tablet: smaller for web
                        : screenWidth > 400
                            ? 70.0 // Large phone
                            : 60.0; // Small phone

                    return GestureDetector(
                      onTap: onImageTap,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: word.imageUrl!,
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => ImageShimmer(
                            width: imageSize,
                            height: imageSize,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, size: imageSize * 0.5),
                        ),
                      ),
                    );
                  },
                ),
              if (word.imageUrl != null)
                SizedBox(width: MediaQuery.of(context).size.width > 600 ? 12 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      word.english,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      word.uzbek,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (word.phonetic != null && word.phonetic!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        word.phonetic!,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    color: Theme.of(context).primaryColor,
                    onPressed: onPlayAudio,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: isWeb ? 20 : 24,
                  ),
                  const SizedBox(height: 4),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: isWeb ? 20 : 24,
                  ),
                ],
              ),
            ],
          ),
          if (word.description != null && word.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 6),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              word.description!,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (word.example != null && word.example!.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 6),
            Text(
              'Example:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              word.example!,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
