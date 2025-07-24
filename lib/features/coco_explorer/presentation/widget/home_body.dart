import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/category_images_riverpod.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/image_query/image_query_riverpod.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/image_query/image_query_state.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/widget/images_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBody extends ConsumerWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<List<int>>>(categoryImagesProvider, (previous, next) {
      // When   loaded image ids, then initialize the image query provider
      next.whenData((imagesId) async {
        await ref.read(imageQueryProvider.notifier).initializeWithIds(imagesId);
      });
    });
    final imagesState = ref.watch(imageQueryProvider);

    return imagesState.when(
      data: (data) {
        return switch (data) {
          ImageQueryInitial() => SizedBox.shrink(),

          ImageQueryLoading() => Center(
            child: CircularProgressIndicator.adaptive(),
          ),

          ImageQueryLoaded(:final imageSegmentations) => ImagesPage(
            images: imageSegmentations,
          ),

          ImageQueryLoadingMore(:final imageSegmentations) => ImagesPage(
            images: imageSegmentations,
            loading: true,
          ),
          ImageQueryLoadedError(:final imageSegmentations, :final message) =>
            ImagesPage(images: imageSegmentations, errorMessage: message),

          ImageQueryError() => Center(child: Text('Error Occurred')),
        };
      },
      error: (error, stackTrace) => Center(child: Text('Error Occurred')),
      loading: () => Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
