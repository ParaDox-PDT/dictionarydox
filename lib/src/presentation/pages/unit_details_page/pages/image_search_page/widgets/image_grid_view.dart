import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/image_search_page/widgets/image_grid_item.dart';
import 'package:flutter/material.dart';

class ImageGridView extends StatelessWidget {
  final List<String> images;
  final String? selectedImage;

  const ImageGridView({
    super.key,
    required this.images,
    this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const Center(child: Text('No images found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final imageUrl = images[index];
        final isSelected = selectedImage == imageUrl;

        return ImageGridItem(
          imageUrl: imageUrl,
          isSelected: isSelected,
        );
      },
    );
  }
}
