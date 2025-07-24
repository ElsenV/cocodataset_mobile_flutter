import 'package:cocodataset_mobile_flutter/core/utils/exceptions/exceptions.dart';
import 'package:cocodataset_mobile_flutter/core/utils/helpers/either.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/images_segmentations_entity.dart';
import 'package:dio/dio.dart';

abstract class IImagesQueryRepository {
  /// Fetches a list of image IDs based on the provided query parameters.
  ///
  /// Returns a [List<int>] representing the image IDs that match the query.
  Future<Either<Failure, List<int>>> getImagesIdsFromCategory({
    required Map<String, dynamic> data,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, List<ImagesSegmentationsEntity>>>
  getImageAndSegmentation({
    required Map<String, dynamic> imageData,
    required Map<String, dynamic> segmentationData,
    CancelToken? cancelToken,
  });
}
