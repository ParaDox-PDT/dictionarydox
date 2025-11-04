import 'package:equatable/equatable.dart';

abstract class ImageSearchState extends Equatable {
  const ImageSearchState();

  @override
  List<Object?> get props => [];
}

class ImageSearchInitial extends ImageSearchState {}

class ImageSearchLoading extends ImageSearchState {}

class ImageSearchLoaded extends ImageSearchState {
  final List<String> images;
  final String? selectedImage;

  const ImageSearchLoaded({
    required this.images,
    this.selectedImage,
  });

  ImageSearchLoaded copyWith({
    List<String>? images,
    String? selectedImage,
  }) {
    return ImageSearchLoaded(
      images: images ?? this.images,
      selectedImage: selectedImage ?? this.selectedImage,
    );
  }

  @override
  List<Object?> get props => [images, selectedImage];
}

class ImageSearchError extends ImageSearchState {
  final String message;

  const ImageSearchError(this.message);

  @override
  List<Object> get props => [message];
}
