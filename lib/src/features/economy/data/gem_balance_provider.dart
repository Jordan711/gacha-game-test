import 'package:flutter_riverpod/flutter_riverpod.dart';

class GemBalanceNotifier extends StateNotifier<int> {
  GemBalanceNotifier() : super(0);

  void add(int amount) {
    if (amount == 0) return;
    state = (state + amount).clamp(0, 9223372036854775807); // int64 max
  }

  bool spend(int cost) {
    if (cost <= state) {
      state -= cost;
      return true;
    }
    return false;
  }
}

final gemBalanceProvider = StateNotifierProvider<GemBalanceNotifier, int>(
  (ref) => GemBalanceNotifier(),
);
