import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/blocs/image_search/image_search_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/image_search/image_search_event.dart';
import 'package:dictionarydox/src/presentation/blocs/image_search/image_search_state.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/image_search_page/widgets/confirm_button.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/image_search_page/widgets/error_view.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/image_search_page/widgets/image_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            return const LoadingGridView();
          }

          if (state is ImageSearchError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context
                    .read<ImageSearchBloc>()
                    .add(SearchImagesForWordEvent(query));
              },
            );
          }

          if (state is ImageSearchLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ImageGridView(
                    images: state.images,
                    selectedImage: state.selectedImage,
                  ),
                ),
                ConfirmButton(selectedImage: state.selectedImage),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
