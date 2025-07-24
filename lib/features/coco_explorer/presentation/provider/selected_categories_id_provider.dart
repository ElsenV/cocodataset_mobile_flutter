import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedItemIdsProvider =
    StateNotifierProvider<SelectedItemIdsNotifier, List<int>>(
      (ref) => SelectedItemIdsNotifier(),
    );

class SelectedItemIdsNotifier extends StateNotifier<List<int>> {
  SelectedItemIdsNotifier() : super([]);

  void toggleSelection(int id) {
    if (state.contains(id)) {
      state = state.where((itemId) => itemId != id).toList();
      return;
    } else {
      state = [...state, id];
    }
  }

  void updateState(List<int> newState) {
    state = {...newState}.toList();
  }

  void addItem(int id) {
    if (!state.contains(id)) {
      state = {...state, id}.toList();
      return;
    }
    state = {...state}.toList();
  }
}
