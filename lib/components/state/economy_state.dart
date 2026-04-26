import 'dart:collection';

import 'package:pair/pair.dart';

class EconomyState {
  double incomeInLastMinute;
  final incomeQueue = Queue<Pair<DateTime, double>>();
  DateTime previousTimeBelowIncomeThreshold;

  EconomyState({this.incomeInLastMinute = 0, previousTimeBelowIncomeThreshold})
      : previousTimeBelowIncomeThreshold =
            previousTimeBelowIncomeThreshold ?? DateTime.now();

  void pruneOldIncomeTicks() {
    // Remove income entries older than 1 minute
    while (incomeQueue.isNotEmpty &&
        DateTime.now().difference(incomeQueue.first.key) >
            Duration(minutes: 1)) {
      incomeInLastMinute -= incomeQueue.first.value;
      incomeQueue.removeFirst();
    }
  }

  void addIncomeTicks(double amount) {
    incomeQueue.add(Pair(DateTime.now(), amount));
    incomeInLastMinute += amount;
  }
}
