import 'package:equatable/equatable.dart';

class ImagesListEntity extends Equatable {
  final int id;
  final String imageUrl;
  final String flickUrl;

  const ImagesListEntity({
    required this.id,
    required this.imageUrl,
    required this.flickUrl,
  });
  @override
  List<Object?> get props => [id, imageUrl, flickUrl];
}
