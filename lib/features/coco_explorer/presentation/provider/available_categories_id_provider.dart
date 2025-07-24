import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/images_segmentations_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final availableCategoryIdsProvider =
    Provider.family<List<int?>, ImagesSegmentationsEntity>((ref, image) {
      final ids = image.segmentations.map((s) => s.categoryId).toSet().toList();
      return [...ids, null];
    });
