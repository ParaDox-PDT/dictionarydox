import 'package:cached_network_image/cached_network_image.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_card.dart';
import 'package:dictionarydox/src/presentation/widgets/image_shimmer.dart';
import 'package:flutter/material.dart';

class WordCarouselCard extends StatelessWidget {
  final dynamic word;
  final VoidCallback onPlayAudio;
  final VoidCallback onDelete;
  final VoidCallback onImageTap;

  const WordCarouselCard({
    super.key,
    required this.word,
    required this.onPlayAudio,
    required this.onDelete,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return DdCard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (word.imageUrl != null) ...[
              GestureDetector(
                onTap: onImageTap,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Responsive image height based on screen size
                    final screenHeight = MediaQuery.of(context).size.height;
                    final screenWidth = MediaQuery.of(context).size.width;
                    final isWeb = screenWidth > 600;
                    
                    // Web uchun kichikroq o'lcham
                    double imageHeight;
                    if (isWeb) {
                      // Web: max 250px yoki screen height ning 25%
                      imageHeight = (screenHeight * 0.25).clamp(150.0, 250.0);
                    } else {
                      // Mobile: screen height ning 25%
                      imageHeight = (screenHeight * 0.25).clamp(150.0, 300.0);
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: imageHeight,
                          maxWidth: double.infinity,
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9, // Maintain aspect ratio
                          child: CachedNetworkImage(
                            imageUrl: word.imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => ImageShimmer(
                              width: double.infinity,
                              height: imageHeight,
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: imageHeight,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.error, size: imageHeight * 0.25),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (word.phonetic != null && word.phonetic!.isNotEmpty) ...[
              Center(
                child: Text(
                  word.phonetic!,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Center(
              child: Text(
                word.english,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                word.uzbek,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[700],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            if (word.description != null && word.description!.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                word.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
            ],
            if (word.example != null && word.example!.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Example',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                word.example!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 12),
            ],
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onPlayAudio,
                    icon: const Icon(Icons.volume_up),
                    label: const Text('Listen'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text('Delete',
                        style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
