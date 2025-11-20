import 'package:dictionarydox/src/presentation/widgets/image_shimmer.dart';
import 'package:flutter/material.dart';

class LoadingGridView extends StatelessWidget {
  const LoadingGridView({super.key});

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
      itemCount: 12,
      itemBuilder: (context, index) {
        return const ImageShimmer(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        );
      },
    );
  }
}
