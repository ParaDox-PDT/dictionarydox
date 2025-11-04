import 'package:dictionarydox/src/domain/usecases/search_images.dart';
import 'package:dictionarydox/src/presentation/blocs/image_search/image_search_event.dart';
import 'package:dictionarydox/src/presentation/blocs/image_search/image_search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageSearchBloc extends Bloc<ImageSearchEvent, ImageSearchState> {
  final SearchImages searchImages;

  ImageSearchBloc({required this.searchImages}) : super(ImageSearchInitial()) {
    on<SearchImagesForWordEvent>(_onSearchImages);
    on<SelectImageFromResultsEvent>(_onSelectImage);
    on<ResetImageSearchEvent>(_onReset);
  }

  Future<void> _onSearchImages(
    SearchImagesForWordEvent event,
    Emitter<ImageSearchState> emit,
  ) async {
    emit(ImageSearchLoading());
    final result = await searchImages(event.query);
    result.fold(
      (failure) => emit(ImageSearchError(failure.message)),
      (images) => emit(ImageSearchLoaded(images: images)),
    );
  }

  void _onSelectImage(
    SelectImageFromResultsEvent event,
    Emitter<ImageSearchState> emit,
  ) {
    if (state is ImageSearchLoaded) {
      final currentState = state as ImageSearchLoaded;
      emit(currentState.copyWith(selectedImage: event.imageUrl));
    }
  }

  void _onReset(ResetImageSearchEvent event, Emitter<ImageSearchState> emit) {
    emit(ImageSearchInitial());
  }
}
