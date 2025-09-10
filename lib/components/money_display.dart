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

    return Text(
      'Money: ${money.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 24,
        color: Colors.white,
      ),
    );
  }
}