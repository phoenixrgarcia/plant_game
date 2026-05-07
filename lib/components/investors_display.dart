import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_game/game_state_provider.dart';

class InvestorsDisplay extends ConsumerWidget {
  final int investors;
  final double incomeInLastMinute;
  final double nextInvestorThreshold;

  const InvestorsDisplay({
    super.key,
    this.investors = 0,
    this.incomeInLastMinute = 0,
    this.nextInvestorThreshold = 100,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investors = ref.watch(
      gameStateManagerProvider
          .select((manager) => manager.state.investorState.investorsAttracted),
    );
    final nextInvestorThreshold = ref.watch(
      gameStateManagerProvider.select(
          (manager) => manager.state.investorState.nextInvestorThreshold()),
    );
    final incomeInLastMinute = ref.watch(gameStateManagerProvider
        .select((manager) => manager.economyState.incomeInLastMinute));

    final progress = nextInvestorThreshold <= 0
        ? 0.0
        : (incomeInLastMinute / nextInvestorThreshold).clamp(0.0, 1.0);

    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.18),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Image.asset(
                'assets/images/wings.png',
                width: 24,
                height: 24,
              ),
              Text(
                ' $investors',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset(
                  'assets/images/coin.png',
                  width: 16,
                  height: 16,
                ),
                Text(
                  ' ${incomeInLastMinute.toStringAsFixed(0)} / min',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 14,
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF76C893),
                  ),
                ),
              ),
            ),
            //const SizedBox(height: 6),
            // Text(
            //   '${incomePerMinute.toStringAsFixed(0)} / ${nextInvestorThreshold.toStringAsFixed(0)}',
            //   style: TextStyle(
            //     fontSize: 12,
            //     color: Colors.white.withValues(alpha: 0.75),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
