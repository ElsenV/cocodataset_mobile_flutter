import 'package:equatable/equatable.dart';

class CategoryItem extends Equatable {
  final String superCategory;
  final int id;
  final String name;

  const CategoryItem({
    required this.superCategory,
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [superCategory, id, name];
}
