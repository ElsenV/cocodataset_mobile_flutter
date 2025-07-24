import 'package:equatable/equatable.dart';

class ImagesListDto extends Equatable {
  final int id;
  final String cocoUrl;
  final String flickrUrl;

  const ImagesListDto({
    required this.id,
    required this.cocoUrl,
    required this.flickrUrl,
  });

  factory ImagesListDto.fromJson(Map<String, dynamic> json) => ImagesListDto(
    id: json["id"],
    cocoUrl: json["coco_url"],
    flickrUrl: json["flickr_url"],
  );
  
  @override
  List<Object?> get props => [id, cocoUrl, flickrUrl];
}
