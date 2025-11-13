import 'package:cached_network_image/cached_network_image.dart';
import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/blocs/image_search/image_search_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/image_search/image_search_event.dart';
import 'package:dictionarydox/src/presentation/blocs/image_search/image_search_state.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_button.dart';
import 'package:dictionarydox/src/presentation/widgets/image_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ImageSearchPage extends StatelessWidget {
  final String query;

  const ImageSearchPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ImageSearchBloc>()..add(SearchImagesForWordEvent(query)),
      child: ImageSearchView(query: query),
    );
  }
}

class ImageSearchView extends StatelessWidget {
  final String query;

  const ImageSearchView({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose an image for "$query"'),
      ),
      body: BlocBuilder<ImageSearchBloc, ImageSearchState>(
        builder: (context, state) {
          if (state is ImageSearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ImageSearchError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ImageSearchBloc>()
                          .add(SearchImagesForWordEvent(query));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ImageSearchLoaded) {
            if (state.images.isEmpty) {
              return const Center(child: Text('No images found'));
            }

            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: state.images.length,
                    itemBuilder: (context, index) {
                      final imageUrl = state.images[index];
                      final isSelected = state.selectedImage == imageUrl;

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
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const ImageShimmer(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.3),
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
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DdButton.primary(
                    text: 'Confirm Selection',
                    onPressed: state.selectedImage != null
                        ? () => context.pop(state.selectedImage)
                        : null,
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
