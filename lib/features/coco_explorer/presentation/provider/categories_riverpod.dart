import 'dart:async';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/category_group_entity.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/data/repository/category_repository_impl.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/category_item_entity.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/repositories/i_category_repository.dart';
import 'package:cocodataset_mobile_flutter/injector.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesNotifier extends AsyncNotifier<List<CategoryGroup>> {
  late final ICategoryRepository _categoryRepository;
  @override
  FutureOr<List<CategoryGroup>> build() async {
    _categoryRepository = getIt<CategoryRepositoryImpl>();
    await getAllCategories();
    return state.value ?? [];
  }

  List<CategoryItem> getFlattenedCategories() {
    final groups = state.valueOrNull ?? [];
    return groups.expand((group) => group.items).toList();
  }

  Future<void> getAllCategories() async {
    final result = await _categoryRepository.getAllCategories(
      cancelToken: CancelToken(),
    );

    return result.fold(
      (error) => state = AsyncError(error, StackTrace.current),
      (data) => state = AsyncData(data),
    );
  }

  
}

final categoriesProvider =
    AsyncNotifierProvider<CategoriesNotifier, List<CategoryGroup>>(
      () => CategoriesNotifier(),
    );
