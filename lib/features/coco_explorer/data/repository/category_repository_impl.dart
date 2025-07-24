import 'package:cocodataset_mobile_flutter/core/utils/exceptions/exceptions.dart';
import 'package:cocodataset_mobile_flutter/core/utils/helpers/either.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/category_group_entity.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/category_item_entity.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/data/remote_data_source/categories_remote_data_source.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/repositories/i_category_repository.dart';
import 'package:dio/dio.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  CategoryRepositoryImpl({
    required ICategoriesRemoteData categoriesRemoteDataSource,
  }) : _categoriesRemoteDataSource = categoriesRemoteDataSource;

  final ICategoriesRemoteData _categoriesRemoteDataSource;

  @override
  Future<Either<Failure, List<CategoryGroup>>> getAllCategories({
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _categoriesRemoteDataSource.getAllCategories(
        cancelToken: cancelToken,
      );

      final categoryGroups = response.entries.map((entry) {
        final categoryItems = entry.value.map((dto) {
          return CategoryItem(
            superCategory: dto.superCategory,
            id: dto.id,
            name: dto.name,
          );
        }).toList();

        return CategoryGroup(categoryName: entry.key, items: categoryItems);
      }).toList();
      return Right(categoryGroups);
    } catch (e) {
      final error = Failure.fromException(e);

      return Left(error);
    }
  }
}
