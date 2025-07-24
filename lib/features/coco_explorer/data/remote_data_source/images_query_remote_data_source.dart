import 'dart:io';
import 'package:cocodataset_mobile_flutter/core/constants/endpoints.dart';
import 'package:cocodataset_mobile_flutter/core/network/i_network_service.dart';
import 'package:cocodataset_mobile_flutter/core/utils/exceptions/exceptions.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/data/model/images_list_dto.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/data/model/images_segmentation_dto.dart';
import 'package:dio/dio.dart';

abstract class ImagesQueryRemoteData {
  /// Fetches the category ID for a given category name.
  ///
  /// Returns an [int] representing the category ID.
  Future<List<int>> getCategoryImagesIds({
    required Map<String, dynamic> data,
    CancelToken? cancelToken,
  });

  Future<List<ImagesListDto>> getImagesByIds({
    required Map<String, dynamic> data,
    CancelToken? cancelToken,
  });

  Future<List<ImagesSegmentationsListDto>> getImageSegmentationByIds({
    required Map<String, dynamic> data,
    CancelToken? cancelToken,
  });
}

class ImagesQueryRemoteDataSourceImpl implements ImagesQueryRemoteData {
  ImagesQueryRemoteDataSourceImpl({required INetworkService networkService})
    : _networkService = networkService;

  final INetworkService _networkService;

  @override
  Future<List<int>> getCategoryImagesIds({
    required Map<String, dynamic> data,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _networkService.post(
        Endpoints.cocoDatasetUrl,
        data: data,
        cancelToken: cancelToken,
      );

      if (response.statusCode == HttpStatus.ok) {
        return List<int>.from(response.data);
      }
      throw ResponseFailure('Failed to fetch category images');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ImagesSegmentationsListDto>> getImageSegmentationByIds({
    required Map<String, dynamic> data,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _networkService.post(
        Endpoints.cocoDatasetUrl,
        data: data,
        cancelToken: cancelToken,
      );

     

      if (response.statusCode == HttpStatus.ok) {

        final result = (response.data as List)
            .map((item) => ImagesSegmentationsListDto.fromJson(item))
            .toList();
        return result;
      }
      throw ResponseFailure('Failed to fetch image segmentation');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ImagesListDto>> getImagesByIds({
    required Map<String, dynamic> data,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _networkService.post(
        Endpoints.cocoDatasetUrl,
        data: data,
        cancelToken: cancelToken,
      );

      if (response.statusCode == HttpStatus.ok) {
        return (response.data as List)
            .map((item) => ImagesListDto.fromJson(item))
            .toList();
      }

      throw ResponseFailure('Failed to fetch images');
    } catch (e) {
      rethrow;
    }
  }
}
