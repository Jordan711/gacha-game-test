import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/src/features/characters/presentation/characters_screen.dart';
import 'package:game/src/features/purchase_gems/presentation/purchase_gems_screen.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/gacha/presentation/gacha_screen.dart';
import '../../features/battle/presentation/battle_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/gacha', builder: (context, state) => const GachaScreen()),
      GoRoute(
        path: '/battle',
        builder: (context, state) => const BattleScreen(),
      ),
      GoRoute(
        path: '/characters',
        builder: (context, state) => const CharactersScreen(),
      ),
      GoRoute(
        path: '/purchase_gems',
        builder: (context, state) => const PurchaseGemsScreen(),
      ),
    ],
  );
});
