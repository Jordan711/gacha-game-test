import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserLevelState {
  final int level;
  final int currentXp;
  final int requiredXp;

  UserLevelState({
    required this.level,
    required this.currentXp,
    required this.requiredXp,
  });

  UserLevelState copyWith({int? level, int? currentXp, int? requiredXp}) {
    return UserLevelState(
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      requiredXp: requiredXp ?? this.requiredXp,
    );
  }
}

class UserLevelNotifier extends StateNotifier<UserLevelState> {
  UserLevelNotifier()
    : super(UserLevelState(level: 1, currentXp: 0, requiredXp: 100));

  void addXp(int amount) {
    if (amount <= 0) return;

    int newXp = state.currentXp + amount;
    int newLevel = state.level;
    int newRequiredXp = state.requiredXp;

    // Level up loop to handle multiple level ups at once
    while (newXp >= newRequiredXp) {
      newXp -= newRequiredXp;
      newLevel++;
      newRequiredXp = _calculateRequiredXp(newLevel);
    }

    state = state.copyWith(
      level: newLevel,
      currentXp: newXp,
      requiredXp: newRequiredXp,
    );
  }

  int _calculateRequiredXp(int level) {
    return (100 * pow(level, 1.5)).toInt();
  }
}

final userLevelProvider =
    StateNotifierProvider<UserLevelNotifier, UserLevelState>((ref) {
      return UserLevelNotifier();
    });
