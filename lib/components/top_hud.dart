import 'package:flutter/material.dart';
import 'package:plant_game/components/investors_display.dart';
import 'package:plant_game/components/money_display.dart';

class TopHud extends StatelessWidget {
  const TopHud({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: const [
              MoneyDisplay(),
              InvestorsDisplay(),
            ],
          ),
        ),
      ),
    );
  }
}
