import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterToggleNotifier extends StateNotifier<bool> {
  FilterToggleNotifier() : super(true);

  void toggle() => state = !state;
}

final filterToggleProvider = StateNotifierProvider<FilterToggleNotifier, bool>(
  (ref) => FilterToggleNotifier(),
);
