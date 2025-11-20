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

  // Calculate responsive crossAxisCount based on screen width
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 6; // Large desktop
    } else if (width > 900) {
      return 5; // Desktop
    } else if (width > 600) {
      return 4; // Tablet
    } else if (width > 400) {
      return 3; // Large phone
    } else {
      return 2; // Small phone
    }
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const Center(child: Text('No images found'));
    }

    final crossAxisCount = _getCrossAxisCount(context);
    final spacing = MediaQuery.of(context).size.width > 600 ? 12.0 : 8.0;

    return GridView.builder(
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.0, // Square images
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
