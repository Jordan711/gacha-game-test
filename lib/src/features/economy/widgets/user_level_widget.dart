import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/src/features/economy/data/user_level_provider.dart';

class UserLevelWidget extends ConsumerWidget {
  const UserLevelWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLevelState = ref.watch(userLevelProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            "LVL ${userLevelState.level}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: userLevelState.requiredXp > 0
                        ? userLevelState.currentXp / userLevelState.requiredXp
                        : 0,
                    backgroundColor: Colors.grey[800],
                    color: Colors.amber,
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${userLevelState.currentXp} / ${userLevelState.requiredXp} XP",
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
