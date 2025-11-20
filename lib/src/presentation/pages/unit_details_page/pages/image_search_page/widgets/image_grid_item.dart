import 'package:cached_network_image/cached_network_image.dart';
import 'package:dictionarydox/src/presentation/blocs/image_search/image_search_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/image_search/image_search_event.dart';
import 'package:dictionarydox/src/presentation/widgets/image_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageGridItem extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;

  const ImageGridItem({
    super.key,
    required this.imageUrl,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ImageSearchBloc>().add(
              SelectImageFromResultsEvent(imageUrl),
            );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 3,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ImageShimmer(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  );
                },
              ),
            ),
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
