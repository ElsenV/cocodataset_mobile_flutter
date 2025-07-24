import 'package:cocodataset_mobile_flutter/core/constants/endpoints.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/domain/entity/category_group_entity.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/category_ui_state_provider.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/selected_categories_id_provider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IconGroupWidget extends ConsumerWidget {
  const IconGroupWidget({super.key, required this.group});
  final CategoryGroup group;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(selectedItemIdsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            group.categoryName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: group.items.map((item) {
              final isSelected = selectedIds.contains(item.id);
              return GestureDetector(
                onTap: () {
                  ref
                      .read(selectedItemIdsProvider.notifier)
                      .toggleSelection(item.id);
                  ref.read(shouldUpdateTextProvider.notifier).state = true;
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue.withAlpha(25)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    key: Key(item.id.toString()),
                    imageUrl: Endpoints.categoryIcon(item.id),
                    fit: BoxFit.contain,
                    width: 32,
                    height: 32,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
