import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/images_segmentations_entity.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/image_query/image_query_riverpod.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/widget/image_with_category_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImagesList extends ConsumerWidget {
  const ImagesList({
    super.key,
    required this.imageSegmentations,
    required this.imageSizes,
    this.loading = false,
    this.errorMessage,
  });

  final List<ImagesSegmentationsEntity> imageSegmentations;
  final Map<String, Size> imageSizes;
  final bool loading;
  final String? errorMessage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        final pixel = notification.metrics.pixels;

        final isMaxPixel = pixel > notification.metrics.maxScrollExtent + 100;
        if (isMaxPixel) {
          ref.read(imageQueryProvider.notifier).fetchLoadMoreImages();
        }

        return false;
      },
      child: ListView.builder(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount:
            imageSegmentations.length +
            (loading || (errorMessage != null) ? 1 : 0),
        itemBuilder: (context, index) {
         
          if (index < imageSegmentations.length) {
            final imageEntity = imageSegmentations[index];
            final originalSize = imageSizes[imageEntity.imageUrl];

            if (originalSize == null) {
              return const SizedBox();
            }
            return ImageWithCategoryFilter(
              key: Key(imageEntity.imageUrl),
              imageEntity: imageEntity,
              originalSize: originalSize,
            );
          }
          return Center(
            child: loading
                ? CircularProgressIndicator.adaptive()
                : errorMessage != null
                ? Text(errorMessage!)
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
