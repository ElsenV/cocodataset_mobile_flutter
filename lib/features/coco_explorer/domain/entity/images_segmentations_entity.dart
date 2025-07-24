import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/segmentation_entity.dart';
import 'package:equatable/equatable.dart';

class ImagesSegmentationsEntity extends Equatable {
  final int imageId;
  final String imageUrl;
  final List<Segmentation> segmentations;

  const ImagesSegmentationsEntity({
    required this.imageId,
    required this.imageUrl,
    required this.segmentations,
  });
  @override
  List<Object?> get props => [imageId, segmentations, imageId];
}
