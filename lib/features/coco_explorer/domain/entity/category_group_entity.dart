import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/category_item_entity.dart';
import 'package:equatable/equatable.dart';

class CategoryGroup extends Equatable {
  final String categoryName;
  final List<CategoryItem> items;

  const CategoryGroup({required this.categoryName, required this.items});

  @override
  List<Object?> get props => [categoryName, items];
}
