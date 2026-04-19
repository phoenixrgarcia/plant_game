import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../game_state_provider.dart';

class MoneyDisplay extends ConsumerWidget {
  const MoneyDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final money = ref.watch(
      gameStateManagerProvider.select((manager) => manager.state.money),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        'Money: ${money.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
