import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/segmentation_entity.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/utils/helper/color_generate.dart';
import 'package:flutter/material.dart';

class SegmentationPainter extends CustomPainter {
  final List<Segmentation> segmentations;
  final Size originalImageSize;
  final Size renderedSize;

  SegmentationPainter({
    required this.segmentations,
    required this.originalImageSize,
    required this.renderedSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fittedSizes = applyBoxFit(
      BoxFit.contain,
      originalImageSize,
      renderedSize,
    );
    final outputRect = Alignment.center.inscribe(
      fittedSizes.destination,
      Offset.zero & renderedSize,
    );

    final scaleX = (outputRect.width / originalImageSize.width);
    final scaleY = (outputRect.height / originalImageSize.height);

    for (final segmentation in segmentations) {
      final paint = Paint()
        ..color = getColorByIndex(segmentation.categoryId)
        ..style = PaintingStyle.fill;
      if (segmentation is PolygonSegmentation) {
        for (final polygon in segmentation.points) {
          final path = Path();
          for (int i = 0; i < polygon.length; i += 2) {
            final x = outputRect.left + polygon[i] * scaleX;
            final y = outputRect.top + polygon[i + 1] * scaleY;
            if (i == 0) {
              path.moveTo(x, y);
            } else {
              path.lineTo(x, y);
            }
          }
          path.close();
          canvas.drawPath(path, paint);
        }
      } else if (segmentation is RLESegmentation) {
        _drawRLE(canvas, segmentation, outputRect, paint);
      }
    }
  }

  void _drawRLE(Canvas canvas, RLESegmentation seg, Rect rect, Paint paint) {
    final width = seg.size[1];
    final height = seg.size[0];
    final scaleX = rect.width / width;
    final scaleY = rect.height / height;

    final pixelPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.fill;

    int x = 0;
    int y = 0;
    bool draw = false;

    for (int count in seg.counts) {
      for (int i = 0; i < count; i++) {
        if (draw) {
          final left = rect.left + x * scaleX;
          final top = rect.top + y * scaleY;
          canvas.drawRect(Rect.fromLTWH(left, top, scaleX, scaleY), pixelPaint);
        }

        x++;
        if (x >= width) {
          x = 0;
          y++;
        }
      }
      draw = !draw;
    }
  }

  @override
  bool shouldRepaint(covariant SegmentationPainter oldDelegate) => false;
}
