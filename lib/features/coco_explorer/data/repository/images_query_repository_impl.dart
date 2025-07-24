import 'package:cocodataset_mobile_flutter/core/utils/exceptions/exceptions.dart';
import 'package:cocodataset_mobile_flutter/core/utils/helpers/either.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/data/remote_data_source/images_query_remote_data_source.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/images_segmentations_entity.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/repositories/i_image_query_repository.dart';
import 'package:dio/dio.dart';

class ImageQueryRepositoryImpl implements IImagesQueryRepository {
  const ImageQueryRepositoryImpl({
    required ImagesQueryRemoteData imagesQueryRemoteDataSource,
  }) : _imagesQueryRemoteDataSource = imagesQueryRemoteDataSource;

  final ImagesQueryRemoteData _imagesQueryRemoteDataSource;

  @override
  Future<Either<Failure, List<int>>> getImagesIdsFromCategory({
    required Map<String, dynamic> data,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _imagesQueryRemoteDataSource.getCategoryImagesIds(
        data: data,
        cancelToken: cancelToken,
      );

      return Right(response);
    } catch (e) {
      final error = Failure.fromException(e);
      return Left(error);
    }
  }

  @override
  Future<Either<Failure, List<ImagesSegmentationsEntity>>>
  getImageAndSegmentation({
    required Map<String, dynamic> imageData,
    required Map<String, dynamic> segmentationData,
    CancelToken? cancelToken,
  }) async {
    try {
      final imagesList = await _imagesQueryRemoteDataSource.getImagesByIds(
        data: imageData,
        cancelToken: cancelToken,
      );
      final segmentationsList = await _imagesQueryRemoteDataSource
          .getImageSegmentationByIds(
            data: segmentationData,
            cancelToken: cancelToken,
          );

      final entities = imagesList.map((image) {
        final imageSegmentations = segmentationsList
            .where((seg) => seg.imageId == image.id)
            .toList();

        return ImagesSegmentationsEntity(
          imageId: image.id,
          imageUrl: image.cocoUrl,
          segmentations: imageSegmentations.map((e) => e.segmentation).toList(),
        );
      }).toList();

      return Right(entities);
    } catch (e) {
      final error = Failure.fromException(e);
      return Left(error);
    }
  }
}
