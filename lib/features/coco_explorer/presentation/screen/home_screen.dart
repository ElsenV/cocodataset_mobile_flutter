import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/categories_riverpod.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/category_images_riverpod.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/category_ui_state_provider.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/filter_toggle_riverpod.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/provider/selected_categories_id_provider.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/widget/filter_body.dart';
import 'package:cocodataset_mobile_flutter/features/coco_explorer/presentation/widget/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController? _autocompleteController;

  @override
  void dispose() {
    _autocompleteController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool shouldUpdateTextField = ref.watch(shouldUpdateTextProvider);
    final isFilterVisible = ref.watch(filterToggleProvider);
    List<int> selectedIds = ref.watch(selectedItemIdsProvider);

    final allCategoriesList = ref
        .read(categoriesProvider.notifier)
        .getFlattenedCategories();

    final selectedCategories = allCategoriesList
        .where((category) => selectedIds.contains(category.id))
        .toList();

    final allNamedCategories = allCategoriesList
        .map((category) => category.name)
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!shouldUpdateTextField) return;
      final names = selectedCategories.map((e) => e.name).join(",");
      _autocompleteController!
        ..text = names
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: names.length),
        );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  final lastWord = textEditingValue.text
                      .split(',')
                      .last
                      .toLowerCase()
                      .trim();
                  return allNamedCategories.where(
                    (option) => option.toLowerCase().startsWith(lastWord),
                  );
                },
                onSelected: (String selection) {
                  final selectedCategory = allCategoriesList.firstWhere(
                    (cat) => cat.name == selection,
                  );
                  ref
                      .read(selectedItemIdsProvider.notifier)
                      .addItem(selectedCategory.id);
                  ref.read(shouldUpdateTextProvider.notifier).state = true;
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onEditingComplete) {
                      _autocompleteController = controller;

                      return TextField(
                        onChanged: (value) {
                          ref.read(shouldUpdateTextProvider.notifier).state =
                              false;
                          if (value.isEmpty) {
                            ref
                                .read(selectedItemIdsProvider.notifier)
                                .updateState([]);
                            return;
                          }

                          final names = value
                              .split(",")
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList();
                          final updatedIds = allCategoriesList
                              .where(
                                (category) => names.contains(category.name),
                              )
                              .map((category) => category.id)
                              .toList();

                          ref
                              .read(selectedItemIdsProvider.notifier)
                              .updateState(updatedIds);
                        },
                        controller: controller,
                        focusNode: focusNode,
                        onEditingComplete: () {
                          ref.read(shouldUpdateTextProvider.notifier).state =
                              true;
                          onEditingComplete();
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: const TextStyle(color: Colors.black54),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 8,
                          ),
                        ),
                        cursorColor: Colors.black,
                      );
                    },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 32,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(option),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.black),
              onPressed: () async {
                if (selectedIds.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select at least one category.'),
                    ),
                  );
                  return;
                }

                if (isFilterVisible) {
                  ref.read(filterToggleProvider.notifier).toggle();
                }

                await ref
                    .read(categoryImagesProvider.notifier)
                    .getCategoryImagesIds(selectedIds);
              },
            ),
          ],
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              !isFilterVisible ? Icons.close : Icons.filter_list,
              color: Colors.black,
            ),
            onPressed: () {
              ref.read(filterToggleProvider.notifier).toggle();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(16),
          child: SizedBox(height: 16),
        ),
      ),

      body: isFilterVisible ? FilterBody() : HomeBody(),
    );
  }
}
