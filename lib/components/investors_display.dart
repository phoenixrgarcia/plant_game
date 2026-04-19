import 'package:flutter/material.dart';

class InvestorsDisplay extends StatelessWidget {
  final int investors;
  final double incomePerMinute;
  final double nextInvestorThreshold;

  const InvestorsDisplay({
    super.key,
    this.investors = 0,
    this.incomePerMinute = 0,
    this.nextInvestorThreshold = 100,
  });

  @override
  Widget build(BuildContext context) {
    final progress = nextInvestorThreshold <= 0
        ? 0.0
        : (incomePerMinute / nextInvestorThreshold).clamp(0.0, 1.0);

    return Container(
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
          Text(
            'Investors: $investors',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${incomePerMinute.toStringAsFixed(0)} / min',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.92),
            ),
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
    );
  }
}
