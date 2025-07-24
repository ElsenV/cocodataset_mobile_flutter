import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/images_segmentations_entity.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/segmentation_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filteredSegmentationsProvider =
    Provider.family<List<Segmentation>, ImagesSegmentationsEntity>((
      ref,
      imageEntity,
    ) {
      final selectedMap = ref.watch(selectedCategoryPerImageProvider);
      final selectedCategoryId = selectedMap[imageEntity.imageId];

      if (selectedCategoryId == null) return imageEntity.segmentations;

      return imageEntity.segmentations
          .where((s) => s.categoryId == selectedCategoryId)
          .toList();
    });

final selectedCategoryPerImageProvider = StateProvider<Map<int, int?>>(
  (ref) => {},
);
