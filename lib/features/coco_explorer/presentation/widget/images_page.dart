
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/images_segmentations_entity.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/utils/helper/image_size.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/widget/images_list.dart';
import 'package:flutter/material.dart';


class ImagesPage extends StatefulWidget {
  final List<ImagesSegmentationsEntity> images;
  final bool loading;
  final String? errorMessage;

  const ImagesPage({
    super.key,
    required this.images,
    this.loading = false,
    this.errorMessage,
  });

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  late Future<Map<String, Size>> _imageSizesFuture;

  @override
  void initState() {
    super.initState();
    _imageSizesFuture = _preloadImageSizes(widget.images);
  }

  Future<Map<String, Size>> _preloadImageSizes(
    List<ImagesSegmentationsEntity> images,
  ) async {
    final Map<String, Size> sizes = {};
    for (var image in images) {
      final size = await getImageSize(image.imageUrl);
      sizes[image.imageUrl] = size;
    }
    return sizes;
  }

  @override
  void didUpdateWidget(covariant ImagesPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.images.length != widget.images.length) {
      _imageSizesFuture = _preloadImageSizes(widget.images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Size>>(
      future: _imageSizesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            widget.images.isEmpty) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        return ImagesList(
          imageSegmentations: widget.images,
          imageSizes: snapshot.data!,
          loading: widget.loading,
          errorMessage: widget.errorMessage,
        );
      },
    );
  }
}
