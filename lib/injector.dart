import 'package:cocodataset_mobile_flutter/core/network/dio/dio_service.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/data/remote_data_source/categories_remote_data_source.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/data/remote_data_source/images_query_remote_data_source.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/data/repository/category_repository_impl.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/data/repository/images_query_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setUpInjector() async {
  getIt
    ..registerLazySingleton(() => Dio())
    ..registerLazySingleton(() => DioService(client: getIt<Dio>()))
    ..registerLazySingleton(
      () => CategoriesRemoteDataSourceImpl(networkService: getIt<DioService>()),
    )
    ..registerLazySingleton(
      () =>
          ImagesQueryRemoteDataSourceImpl(networkService: getIt<DioService>()),
    )
    ..registerLazySingleton(
      () => CategoryRepositoryImpl(
        categoriesRemoteDataSource: getIt<CategoriesRemoteDataSourceImpl>(),
      ),
    )
    ..registerLazySingleton(
      () => ImageQueryRepositoryImpl(
        imagesQueryRemoteDataSource: getIt<ImagesQueryRemoteDataSourceImpl>(),
      ),
    );
}
