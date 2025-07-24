import 'package:equatable/equatable.dart';

class CategoryItemDto extends Equatable {
  final String superCategory;
  final int id;
  final String name;

  const CategoryItemDto({
    required this.superCategory,
    required this.id,
    required this.name,
  });

  factory CategoryItemDto.fromJson(Map<String, dynamic> json) {
    return CategoryItemDto(
      superCategory: json['supercategory'] ?? '',
      id: json['id'] ?? -1,
      name: json['name'] ?? '',
    );
  }

  @override
  List<Object?> get props => [superCategory, id, name];
}
