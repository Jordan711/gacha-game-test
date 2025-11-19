import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/core/theme/app_theme.dart';
import 'src/core/routing/router_provider.dart';

class GachaGameApp extends ConsumerStatefulWidget {
  const GachaGameApp({super.key});

  @override
  ConsumerState<GachaGameApp> createState() => _GachaGameAppState();
}

class _GachaGameAppState extends ConsumerState<GachaGameApp> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    _audioPlayer.play(AssetSource('audio/techno_synth04.ogg'));

    return MaterialApp.router(
      title: 'Gacha Battler',
      theme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
