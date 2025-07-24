import 'dart:convert';

import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/segmentation_entity.dart';
import 'package:equatable/equatable.dart';

class ImagesSegmentationsListDto extends Equatable {
  final int imageId;
  final Segmentation segmentation;
  final int categoryId;

  const ImagesSegmentationsListDto({
    required this.imageId,
    required this.segmentation,
    required this.categoryId,
  });

  factory ImagesSegmentationsListDto.fromJson(Map<String, dynamic> json) {
    final seg = json['segmentation'];
    final categoryId = json['category_id'];
    final imageId = json['image_id'];

    late Segmentation segmentation;

    if (seg is String) {
      final decoded = jsonDecode(seg);
      segmentation = _parseSegmentation(decoded, categoryId: categoryId);
    } else {
      segmentation = _parseSegmentation(seg, categoryId: categoryId);
    }

    return ImagesSegmentationsListDto(
      imageId: imageId,
      segmentation: segmentation,
      categoryId: categoryId,
    );
  }

  static Segmentation _parseSegmentation(
    dynamic raw, {
    required int categoryId,
  }) {
    if (raw is List) {
      return PolygonSegmentation(
        points: raw
            .map<List<double>>(
              (inner) =>
                  (inner as List).map((e) => (e as num).toDouble()).toList(),
            )
            .toList(),
        categoryId: categoryId,
      );
    } else if (raw is Map) {
      final counts = (raw['counts'] as List)
          .map((e) => (e as num).toInt())
          .toList();
      final size = (raw['size'] as List)
          .map((e) => (e as num).toInt())
          .toList();

      return RLESegmentation(
        counts: counts,
        size: size,
        categoryId: categoryId,
      );
    } else {
      throw Exception('Unknown segmentation format: $raw');
    }
  }

  @override
  List<Object?> get props => [imageId, segmentation, categoryId];
}
