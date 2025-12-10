import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryProvider extends StateNotifier<List<String>> {
  InventoryProvider() : super([]);

  void addItem(String item) {
    state = [...state, item];
  }

  void removeItem(String item) {
    state = state.where((element) => element != item).toList();
  }

  void clear() {
    state = [];
  }
}

final inventoryProvider =
    StateNotifierProvider<InventoryProvider, List<String>>(
      (ref) => InventoryProvider(),
    );
