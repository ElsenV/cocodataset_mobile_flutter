import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/categories_riverpod.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/widget/icon_group_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterBody extends ConsumerWidget {
  const FilterBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    return Center(
      child: categories.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final group = data[index];

              return IconGroupWidget(group: group);
            },
          );
        },
        loading: () => const CircularProgressIndicator.adaptive(),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }
}
