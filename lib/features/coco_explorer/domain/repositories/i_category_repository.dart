import 'package:cocodataset_mobile_flutter/core/utils/exceptions/exceptions.dart';
import 'package:cocodataset_mobile_flutter/core/utils/helpers/either.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/category_group_entity.dart';
import 'package:dio/dio.dart';

abstract class ICategoryRepository {
  Future<Either<Failure, List<CategoryGroup>>> getAllCategories({
    CancelToken? cancelToken,
  });
}
