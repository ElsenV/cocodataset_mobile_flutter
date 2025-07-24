import 'dart:convert';

import 'package:cocodataset_mobile_flutter/core/constants/endpoints.dart';
import 'package:cocodataset_mobile_flutter/core/network/i_network_service.dart';
import 'package:cocodataset_mobile_flutter/core/utils/exceptions/exceptions.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/data/model/category_item_dto.dart';
import 'package:dio/dio.dart';

abstract class ICategoriesRemoteData {
  /// Returns a [List] of [String] representing the category name,id.
  Future<Map<String, List<CategoryItemDto>>> getAllCategories({
    CancelToken? cancelToken,
  });
}

class CategoriesRemoteDataSourceImpl implements ICategoriesRemoteData {
  CategoriesRemoteDataSourceImpl({required INetworkService networkService})
    : _networkService = networkService;

  final INetworkService _networkService;

  // Response  is a JS file, so I used regex to extract the categories

  @override
  Future<Map<String, List<CategoryItemDto>>> getAllCategories({
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _networkService.get(
        Endpoints.cocoCategoriesUrl,
        cancelToken: cancelToken,
      );

      final jsText = response.data as String;

      final regex = RegExp(r'var categories = (\{.*?\});', dotAll: true);
      final match = regex.firstMatch(jsText);

      if (match != null) {
        final jsonString = match.group(1)!;
        final fixedJson = jsonString.replaceAll("'", '"');
        final jsonMap = jsonDecode(fixedJson) as Map<String, dynamic>;

        final result = jsonMap.map((key, value) {
          final list = (value as List)
              .map((e) => CategoryItemDto.fromJson(e as Map<String, dynamic>))
              .toList();

          return MapEntry(key, list);
        });

        return result;
      } else {
        throw ResponseFailure('Categories not found');
      }
    } catch (e) {
      rethrow;
    }
  }
}
