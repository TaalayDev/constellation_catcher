import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/theme_provider.dart';

class BackgroundGradient extends HookConsumerWidget {
  const BackgroundGradient({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(gameThemeProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: theme.config.backgroundGradient,
        ),
      ),
      child: child,
    );
  }
}
