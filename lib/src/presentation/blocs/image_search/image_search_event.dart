import 'package:equatable/equatable.dart';

abstract class ImageSearchEvent extends Equatable {
  const ImageSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchImagesForWordEvent extends ImageSearchEvent {
  final String query;

  const SearchImagesForWordEvent(this.query);

  @override
  List<Object> get props => [query];
}

class SelectImageFromResultsEvent extends ImageSearchEvent {
  final String imageUrl;

  const SelectImageFromResultsEvent(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class ResetImageSearchEvent extends ImageSearchEvent {}
