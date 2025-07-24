import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocodataset_mobile_flutter/core/constants/endpoints.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/images_segmentations_entity.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/available_categories_id_provider.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/category_filter_provider.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/widget/segmentation_over_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageWithCategoryFilter extends ConsumerWidget {
  const ImageWithCategoryFilter({
    required this.imageEntity,
    required this.originalSize,
    super.key,
  });
  final ImagesSegmentationsEntity imageEntity;
  final Size originalSize;
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final filteredSegmentations = ref.watch(
      filteredSegmentationsProvider(imageEntity),
    );
    final categories = ref.read(availableCategoryIdsProvider(imageEntity));
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((id) {
              return GestureDetector(
                onTap: () => ref
                    .read(selectedCategoryPerImageProvider.notifier)
                    .update((state) => {...state, imageEntity.imageId: id}),

                child: CachedNetworkImage(
                  key: Key(id.toString()),
                  imageUrl: Endpoints.categoryIcon(id),
                  fit: BoxFit.contain,
                  width: 32,
                  height: 32,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          SegmentationOverImage(
            imageUrl: imageEntity.imageUrl,
            originalImageSize: originalSize,
            segmentations: filteredSegmentations,
          ),
        ],
      ),
    );
  }
}
