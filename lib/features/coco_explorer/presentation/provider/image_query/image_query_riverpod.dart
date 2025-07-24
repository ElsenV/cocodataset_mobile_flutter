import 'dart:async';

import 'package:cocodataset_mobile_flutter/features/coco_explorer/data/repository/images_query_repository_impl.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/images_segmentations_entity.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/repositories/i_image_query_repository.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/image_query/image_query_state.dart';
import 'package:cocodataset_mobile_flutter/injector.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageQueryNotifier extends AsyncNotifier<ImageQueryState> {
  late final IImagesQueryRepository _imageQueryRepository;
  @override
  FutureOr<ImageQueryState> build() {
    _imageQueryRepository = getIt<ImageQueryRepositoryImpl>();
    return state.value ?? const ImageQueryInitial();
  }

  final int batchSize = 5;
  List<int> allIds = [];
  int currentIndex = 0;

  Future<void> initializeWithIds(List<int> ids) async {
    allIds = ids;
    currentIndex = 0;
    state = AsyncValue.data(ImageQueryLoading());
    await _fetchToImages([], isFirst: true);
  }

  Future<void> fetchLoadMoreImages() async {
    List<ImagesSegmentationsEntity> itemList = [];
    if (currentIndex >= allIds.length) {
      return;
    }

    if (state is AsyncLoading ||
        state.value is ImageQueryLoading ||
        state.value is ImageQueryLoadingMore) {
      // Already loading, do not fetch again
      return;
    }

    if (state.value is ImageQueryLoaded) {
      itemList = (state.value as ImageQueryLoaded).imageSegmentations;
    } else if (state.value is ImageQueryLoadedError) {
      itemList = (state.value as ImageQueryLoadedError).imageSegmentations;
    }

    state = AsyncValue.data(
      ImageQueryLoadingMore(imageSegmentations: itemList),
    );
    await _fetchToImages(itemList);
  }

  Future<void> _fetchToImages(
    List<ImagesSegmentationsEntity> previousList, {
    bool isFirst = false,
  }) async {
    final imagesId = allIds.skip(currentIndex).take(batchSize).toList();

    if (imagesId.isEmpty) {
      return;
    }

    final segmentationData = <String, dynamic>{
      'image_ids[]': imagesId,
      "querytype": "getInstances",
    };
    final imagesData = <String, dynamic>{
      'image_ids[]': imagesId,
      "querytype": "getImages",
    };
    final result = await _imageQueryRepository.getImageAndSegmentation(
      imageData: imagesData,
      segmentationData: segmentationData,
      cancelToken: CancelToken(),
    );
    return result.fold(
      (failure) {
        if (isFirst) {
          state = AsyncError(
            ImageQueryError(failure.message),
            StackTrace.current,
          );
          return;
        }
        state = AsyncValue.data(
          ImageQueryLoadedError(
            imageSegmentations: previousList,
            message: failure.message,
          ),
        );
      },
      (imagesSegmentations) {
        currentIndex += batchSize;

        state = AsyncValue.data(
          ImageQueryLoaded([...previousList, ...imagesSegmentations]),
        );
      },
    );
  }
}

final imageQueryProvider =
    AsyncNotifierProvider<ImageQueryNotifier, ImageQueryState>(
      () => ImageQueryNotifier(),
    );
