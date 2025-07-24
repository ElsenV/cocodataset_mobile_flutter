import 'dart:async';

import 'package:cocodataset_mobile_flutter/features/coco_explorer/data/repository/images_query_repository_impl.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/repositories/i_image_query_repository.dart';
import 'package:cocodataset_mobile_flutter/injector.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryImagesNotifier extends AsyncNotifier<List<int>> {
  late final IImagesQueryRepository _categoryRepository;
  @override
  FutureOr<List<int>> build() {
    _categoryRepository = getIt<ImageQueryRepositoryImpl>();
    return state.value ?? [];
  }

  Future<void> getCategoryImagesIds(List<int> categoryIds) async {
    state = const AsyncValue.loading();
    final data = {
      "category_ids[]": categoryIds,
      "querytype": "getImagesByCats",
    };
    final result = await _categoryRepository.getImagesIdsFromCategory(
      data: data,
      cancelToken: CancelToken(),
    );
    result.fold(
      (failure) {
        return state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (imagesIds) {
        return state = AsyncValue.data(imagesIds);
      },
    );
  }
}

final categoryImagesProvider =
    AsyncNotifierProvider<CategoryImagesNotifier, List<int>>(
      () => CategoryImagesNotifier(),
    );
