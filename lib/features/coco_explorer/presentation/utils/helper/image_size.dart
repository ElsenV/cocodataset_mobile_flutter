import 'dart:async';
import 'package:flutter/widgets.dart';

// get image size for segmentation  to be positioned correctly
Future<Size> getImageSize(String imageUrl) async {
  final completer = Completer<Size>();
  final image = NetworkImage(imageUrl);

  image
      .resolve(const ImageConfiguration())
      .addListener(
        ImageStreamListener((ImageInfo info, _) {
          final mySize = Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
          completer.complete(mySize);
        }),
      );

  return completer.future;
}
