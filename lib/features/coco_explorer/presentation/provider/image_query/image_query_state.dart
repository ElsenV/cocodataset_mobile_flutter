import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/images_segmentations_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ImageQueryState extends Equatable {
  const ImageQueryState();

  @override
  List<Object?> get props => [];
}

class ImageQueryInitial extends ImageQueryState {
  const ImageQueryInitial();
}

class ImageQueryLoading extends ImageQueryState {
  const ImageQueryLoading();
}

class ImageQueryLoaded extends ImageQueryState {
  final List<ImagesSegmentationsEntity> imageSegmentations;

  const ImageQueryLoaded(this.imageSegmentations);

  @override
  List<Object?> get props => [imageSegmentations];
}

class ImageQueryLoadingMore extends ImageQueryState {
  final List<ImagesSegmentationsEntity> imageSegmentations;

  const ImageQueryLoadingMore({required this.imageSegmentations});

  @override
  List<Object?> get props => [imageSegmentations];
}

class ImageQueryError extends ImageQueryState {
  final String message;

  const ImageQueryError(this.message);

  @override
  List<Object?> get props => [message];
}

class ImageQueryLoadedError extends ImageQueryState {
  final List<ImagesSegmentationsEntity> imageSegmentations;
  final String message;

  const ImageQueryLoadedError({
    required this.imageSegmentations,
    required this.message,
  });

  @override
  List<Object?> get props => [message, imageSegmentations];
}
