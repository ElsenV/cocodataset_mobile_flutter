import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/segmentation_entity.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/widget/segmentation_painter.dart';
import 'package:flutter/material.dart';

// SegmentationOverImage widget that displays an image with segmentations drawn over it

// TODO: wrap image and segmentation in the same layout.

class SegmentationOverImage extends StatelessWidget {
  final String imageUrl;
  final Size originalImageSize;
  final List<Segmentation> segmentations;

  const SegmentationOverImage({
    required this.imageUrl,
    required this.originalImageSize,
    required this.segmentations,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final aspectRatio = originalImageSize.width / originalImageSize.height;

        final width = constraints.maxWidth;
        final height = width / aspectRatio;

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.contain),
              CustomPaint(
                painter: SegmentationPainter(
                  segmentations: segmentations,
                  originalImageSize: originalImageSize,
                  renderedSize: Size(width, height),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
